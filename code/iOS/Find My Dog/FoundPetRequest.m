//
//  RemoveAlertRequest.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 19/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "FoundPetRequest.h"

@implementation FoundPetRequest

+ (void)requestWithPetID:(NSString *)petID queue:(NSOperationQueue *)queue
{    
    NSString *urlString = [[NSString alloc] initWithFormat:@"/pets/%@/found/", petID];
    NSString *urlSigned = [BaseRequest urlSignedWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlSigned]
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
	// now lets make the connection to the web
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error)
     {

     }];
}

@end
