//
//  LoadReportImageRequest.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 04/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "LoadReportImageRequest.h"
//#import "User.h"
#import "Report.h"

@implementation LoadReportImageRequest

+ (void)requestWithID:(NSString *)reportID queue:(NSOperationQueue *)queue
{
    NSString *urlString = [[NSString alloc] initWithFormat:@"/reports/%@/image/", reportID];
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
             NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:reportID, @"reportID", data, @"data", nil];
             NSNotification *notif = [NSNotification
                                      notificationWithName:@"NetworkManagerDidLoadImageReportNotification"
                                      object:self
                                      userInfo:dict];
             
             [[NSNotificationCenter defaultCenter] postNotification:notif];
         }
     }];
}

@end
