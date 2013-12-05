//
//  SaveAlertRequest.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 11/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "BaseRequest.h"

@interface MissingPetRequest : BaseRequest

+ (void)requestWithPetId:(NSString *)petID lattitude:(double)lattitude longitude:(double)longitude queue:(NSOperationQueue *)queue;

@end
