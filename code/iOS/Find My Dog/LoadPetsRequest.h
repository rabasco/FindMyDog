//
//  LoadPetsRequest.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 09/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "BaseRequest.h"

@interface LoadPetsRequest : BaseRequest

+ (void)requestWithQueue:(NSOperationQueue *)queue;

@end
