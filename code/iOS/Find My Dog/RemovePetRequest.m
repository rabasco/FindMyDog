//
//  RemovePetRequest.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 19/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "RemovePetRequest.h"

@implementation RemovePetRequest

+ (void)requestWithPetId:(NSString *)petID queue:(NSOperationQueue *)queue
{
    NSString *urlString = [[NSString alloc] initWithFormat:@"/pets/%@/", petID];
    NSString *urlSigned = [BaseRequest urlSignedWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlSigned]
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60];
    [request setHTTPMethod:@"DELETE"];
    
	// now lets make the connection to the web
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == nil)
         {
             NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:petID, @"petID", nil];
             NSNotification *notif = [NSNotification
                                      notificationWithName:@"NetworkManagerDidRemovePetNotification"
                                      object:self
                                      userInfo:dict];
             
             [[NSNotificationCenter defaultCenter] postNotification:notif];
         }
     }];
}

@end
