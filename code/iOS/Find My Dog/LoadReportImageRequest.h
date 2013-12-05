//
//  LoadReportImageRequest.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 04/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@interface LoadReportImageRequest : BaseRequest

+ (void)requestWithID:(NSString *)reportID queue:(NSOperationQueue *)queue;

@end
