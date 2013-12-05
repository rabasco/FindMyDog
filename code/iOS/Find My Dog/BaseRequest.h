//
//  BaseRequest.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 17/06/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kServer @"http://localhost:8080"
#define kAPIName @"/platform_services"

@interface BaseRequest : NSObject

+ (NSString *)urlSignedWithString:(NSString *)urlString;
+ (NSString *)urlSignedNoAPIKeyWithString:(NSString *)urlString;

@end
