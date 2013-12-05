//
//  SavePetRequest.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 08/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "SavePetRequest.h"
#import "Pet.h"

@implementation SavePetRequest

+ (void)requestWithImageData:(NSData *)data name:(NSString *)name queue:(NSOperationQueue *)queue
{
    NSString *urlString = [[NSString alloc] initWithFormat:@"/pets/?name=%@", [name stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    
    NSString *urlSigned = [BaseRequest urlSignedWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlSigned]
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60];
    
    [request setHTTPMethod:@"POST"];
    
    // We need to add a header field named Content-Type with a value that tells that it's a form and also add a boundary.
    // I just picked a boundary by using one from a previous trace, you can just copy/paste from the traces.
    NSString *boundary = @"----WebKitFormBoundarycC4YiaUFwM44F6rT";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    // end of what we've added to the header
    
    // the body of the post
    NSMutableData *body = [NSMutableData data];
    
    // Now we need to append the different data 'segments'. We first start by adding the boundary.
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
    // Now append the image
    // Note that the name of the form field is exactly the same as in the trace ('attachment[file]' in my case)!
    // You can choose whatever filename you want.
    [body appendData:[@"Content-Disposition: form-data; name=\"file\";filename=\"picture.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // We now need to tell the receiver what content type we have
    // In my case it's a png image. If you have a jpg, set it to 'image/jpg'
    [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Now we append the actual image data
    [body appendData:[NSData dataWithData:data]];
    
    // and again the delimiting boundary
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
    // adding the body we've created to the request
    [request setHTTPBody:body];
   	
	// now lets make the connection to the web
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSDictionary *dict;
         
         if (error == nil)
         {
             NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             NSString *petId = [resultDic objectForKey:@"id"];
             
             dict = [[NSDictionary alloc] initWithObjectsAndKeys:petId, @"petID", nil];
         }
         else
         {
             dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"ERROR_CONNECTION", @"error", nil];
         }
         
         NSNotification *notif = [NSNotification
                                  notificationWithName:@"NetworkManagerDidSavePetNotification"
                                  object:self
                                  userInfo:dict];
         
         [[NSNotificationCenter defaultCenter] postNotification:notif];
     }];
    
    
}

@end
