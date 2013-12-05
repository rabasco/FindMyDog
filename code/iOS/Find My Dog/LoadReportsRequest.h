//
//  LoadReportsRequest.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 05/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@interface LoadReportsRequest : BaseRequest

+ (void)requestWithLattitude:(double)lattitude longitude:(double)longitude lastCheckTimestamp:(long)lastCheckTimestamp queue:(NSOperationQueue *)queue;

@end
