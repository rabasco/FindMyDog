//
//  LoadAlertRequest.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 14/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "BaseRequest.h"

@interface LoadAlertRequest : BaseRequest

+ (void)requestWithQueue:(NSOperationQueue *)queue;

@end
