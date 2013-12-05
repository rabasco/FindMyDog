//
//  SaveAlertRequest.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 11/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "MissingPetRequest.h"

@implementation MissingPetRequest

+ (void)requestWithPetId:(NSString *)petID lattitude:(double)lattitude longitude:(double)longitude queue:(NSOperationQueue *)queue;
{
    NSString *urlString = [[NSString alloc] initWithFormat:@"/pets/%@/missing/?longitude=%f&lattitude=%f", petID, longitude, lattitude];
    NSString *urlSigned = [BaseRequest urlSignedWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlSigned]
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == nil)
         {
             NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:petID, @"petID",
                                        [[NSNumber alloc] initWithDouble:longitude], @"longitude",
                                        [[NSNumber alloc] initWithDouble:lattitude], @"lattitude", nil];
             
             NSNotification *notif = [NSNotification
                                      notificationWithName:@"NetworkManagerDidMissingPetNotification"
                                      object:self
                                      userInfo:dict];
             
             [[NSNotificationCenter defaultCenter] postNotification:notif];
         }
     }];
}

@end
