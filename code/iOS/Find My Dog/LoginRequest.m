//
//  LoginRequest.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 17/06/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "LoginRequest.h"

@implementation LoginRequest

+ (void)requestWithEmail:(NSString *)email secret:(NSString *)secret queue:(NSOperationQueue *)queue
{
    NSString *urlString = [[NSString alloc] initWithFormat:@"/users/apikey/?email=%@",
                             [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *urlSigned = [BaseRequest urlSignedNoAPIKeyWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlSigned]
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
        ^(NSURLResponse *response, NSData *data, NSError *error)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSNotification *notif = nil;
            
            if (error == nil && [[dict objectForKey:@"apikey"] length] > 0)
            {
                notif = [NSNotification notificationWithName:@"NetworkManagerDidLoginNotification"
                                                      object:self
                                                    userInfo:dict];
            }
            else
            {
                notif = [NSNotification notificationWithName:@"NetworkManagerLoginErrorNotification"
                                                      object:self
                                                    userInfo:nil];
            }
            
            [[NSNotificationCenter defaultCenter] postNotification:notif];
        }];
}

@end
