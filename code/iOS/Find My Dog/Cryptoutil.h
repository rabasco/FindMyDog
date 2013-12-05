//
//  Cryptoutil.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 02/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface Cryptoutil : NSObject

+ (NSString*) sha1:(NSString*)input;
+ (NSString*) sha256:(NSString*)input;

@end
