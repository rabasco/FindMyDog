//
//  LoginRequest.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 17/06/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@interface LoginRequest : BaseRequest 

+ (void)requestWithEmail:(NSString *)email secret:(NSString *)secret queue:(NSOperationQueue *)queue;

@end
