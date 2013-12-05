//
//  BaseRequest.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 17/06/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "BaseRequest.h"
#import "ConfigurationStore.h"
#import "Cryptoutil.h"

@implementation BaseRequest

+ (NSString *)urlSignedWithString:(NSString *)urlString
{
    Configuration *config = [[ConfigurationStore defaultStore] configuration];
    
    NSString *url;

    // Add kAPIName and apikey
    if ([urlString characterAtIndex:[urlString length]-1] == '/')
    {
        url = [[NSString alloc] initWithFormat:@"%@%@?apikey=%@", kAPIName, urlString, config.apikey];
    }
    else {
        url = [[NSString alloc] initWithFormat:@"%@%@&apikey=%@", kAPIName, urlString, config.apikey];
    }

    NSString *urlToEncode = [[NSString alloc] initWithFormat:@"%@%@", url, config.secret];
    NSString *sign = [Cryptoutil sha256:urlToEncode];
    
    url = [[NSString alloc] initWithFormat:@"%@%@&sign=%@", kServer, url, sign];
    
    return url;
}

+ (NSString *)urlSignedNoAPIKeyWithString:(NSString *)urlString
{
    Configuration *config = [[ConfigurationStore defaultStore] configuration];
    
    NSString *url;
    
    // Add kAPIName
    url = [[NSString alloc] initWithFormat:@"%@%@", kAPIName, urlString];
    
    NSString *urlToEncode = [[NSString alloc] initWithFormat:@"%@%@", url, config.secret];
    NSString *sign = [Cryptoutil sha256:urlToEncode];
    
    url = [[NSString alloc] initWithFormat:@"%@%@&sign=%@", kServer, url, sign];
    
    return url;
}


@end
