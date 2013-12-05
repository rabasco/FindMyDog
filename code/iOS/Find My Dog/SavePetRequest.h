//
//  SavePetRequest.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 08/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@interface SavePetRequest : BaseRequest

+ (void)requestWithImageData:(NSData *)data name:(NSString *)name queue:(NSOperationQueue *)queue;

@end
