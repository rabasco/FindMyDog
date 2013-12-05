//
//  LoadReportsRequest.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 05/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "LoadReportsRequest.h"
//#import "User.h"

@implementation LoadReportsRequest

+ (void)requestWithLattitude:(double)lattitude longitude:(double)longitude lastCheckTimestamp:(long)lastCheckTimestamp queue:(NSOperationQueue *)queue
{
    NSString *urlString = [[NSString alloc] initWithFormat:@"/reports/?x=%f&y=%f&timestamp=%ld", longitude, lattitude, lastCheckTimestamp];
    NSString *urlSigned = [BaseRequest urlSignedWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlSigned]
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60];

	// now lets make the connection to the web
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == nil)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             NSNotification *notif = [NSNotification
                                      notificationWithName:@"NetworkManagerDidLoadReportsNotification"
                                      object:self
                                      userInfo:dict];
             
             [[NSNotificationCenter defaultCenter] postNotification:notif];
         }
     }];

}

@end
