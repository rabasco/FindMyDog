//
//  LoadPetImageRequest.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 19/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "LoadPetImageRequest.h"

@implementation LoadPetImageRequest

+ (void)requestWithId:(NSString *)petId queue:(NSOperationQueue *)queue
{
    NSString *urlString = [[NSString alloc] initWithFormat:@"/pets/%@/image/", petId];
    NSString *urlSigned = [BaseRequest urlSignedWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlSigned]
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60];
    
	// now lets make the connection to the web
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSDictionary *dict = nil;
         
         if (error == nil)
         {
             dict = [[NSDictionary alloc] initWithObjectsAndKeys:data, @"data", petId, @"petID", nil];
         }
         else
         {
             dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"ERROR_CONNECTION", @"error", nil];
         }
         
         NSNotification *notif = [NSNotification
                                  notificationWithName:@"NetworkManagerDidLoadPetImageNotification"
                                  object:self
                                  userInfo:dict];
         
         [[NSNotificationCenter defaultCenter] postNotification:notif];
     }];
    
}

@end
