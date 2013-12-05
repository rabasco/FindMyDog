//
//  RemovePetRequest.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 19/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "BaseRequest.h"

@interface RemovePetRequest : BaseRequest

+ (void)requestWithPetId:(NSString *)petID queue:(NSOperationQueue *)queue;

@end
