//
//  LoadPetsRequest.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 09/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "LoadPetsRequest.h"

@implementation LoadPetsRequest

+ (void)requestWithQueue:(NSOperationQueue *)queue
{
    NSString *urlString = [[NSString alloc] initWithFormat:@"/pets/"];
    NSString *urlSigned = [BaseRequest urlSignedWithString:urlString];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlSigned]
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == nil)
         {
             NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             
             NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:array, @"array", nil];
             
             NSNotification *notif = [NSNotification notificationWithName:@"NetworkManagerDidLoadPetsNotification"
                                                                   object:self
                                                                 userInfo:dict];
             
             [[NSNotificationCenter defaultCenter] postNotification:notif];
         }
         else
         {
             NSNotification *notif = [NSNotification notificationWithName:@"NetworkManagerDidLoadPetsErrorNotification"
                                                                   object:self
                                                                 userInfo:nil];

             [[NSNotificationCenter defaultCenter] postNotification:notif];
         }
     }];
}

@end
