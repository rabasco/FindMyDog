//
//  SendReportRequest.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 02/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@interface SendReportRequest : BaseRequest

+ (void)requestWithImageData:(NSData *)imageData lattitude:(double)lattitude longitude:(double)longitude queue:(NSOperationQueue *)queue;

@end
