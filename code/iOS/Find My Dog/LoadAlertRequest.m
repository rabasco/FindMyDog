//
//  LoadAlertRequest.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 14/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "LoadAlertRequest.h"

@implementation LoadAlertRequest

+ (void)requestWithQueue:(NSOperationQueue *)queue
{
    NSString *urlString = [[NSString alloc] initWithFormat:@"/alerts/"];
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
             dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         }
         else
         {
             dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"ERROR_CONNECTION", @"error", nil];
         }
         
         NSNotification *notif = [NSNotification
                                  notificationWithName:@"NetworkManagerDidLoadAlertNotification"
                                  object:self
                                  userInfo:dict];
         
         [[NSNotificationCenter defaultCenter] postNotification:notif];
     }];
}

@end
