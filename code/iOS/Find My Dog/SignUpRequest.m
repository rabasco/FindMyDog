//
//  SignUpRequest.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 29/06/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "SignUpRequest.h"
#import "ConfigurationStore.h"

@implementation SignUpRequest

+ (void)requestWithUsername:(NSString *)username email:(NSString *)email secret:(NSString *)secret queue:(NSOperationQueue *)queue
{
    // Save configuration
    Configuration *config = [[ConfigurationStore defaultStore] configuration];
    [config setUsername:username];
    [config setEmail:email];
    [config setSecret:secret];
    
    NSString *urlAsString = [[NSString alloc] initWithFormat:@"%@%@/users/?username=%@&email=%@&secret=%@",
                             kServer,
                             kAPIName,
                             [username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                             [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                             [secret stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         NSNotification *notif = nil;
         
         if (error == nil && [[dict objectForKey:@"apikey"] length] > 0)
         {
             [config setApikey:[dict objectForKey:@"apikey"]];
             notif = [NSNotification notificationWithName:@"NetworkManagerDidSignUpNotification"
                                                   object:self
                                                 userInfo:nil];
         }
         else
         {
             notif = [NSNotification notificationWithName:@"NetworkManagerSignUpErrorNotification"
                                                   object:self
                                                 userInfo:nil];
         }
         
         [[NSNotificationCenter defaultCenter] postNotification:notif];
     }];
}

@end
