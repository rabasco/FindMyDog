//
//  SignUpRequest.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 29/06/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@interface SignUpRequest : BaseRequest

+ (void)requestWithUsername:(NSString *)username email:(NSString *)email secret:(NSString *) secret queue:(NSOperationQueue *)queue;

@end
