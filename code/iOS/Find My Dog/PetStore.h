//
//  DataModel.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 14/09/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractStore.h"
#import "Pet.h"

@interface PetStore : AbstractStore
{
    NSMutableDictionary *pets;
}

+ (PetStore *)defaultStore;

- (NSMutableDictionary *)pets;
- (void)missingPetWithID:(NSString *)petID lattitude:(double)lattitude longitude:(double)longitude;
- (void)setPetFoundWithID:(NSString *)petID;
- (void)deletePetWithID:(NSString *)petID;
- (Pet *)createPetWithName:(NSString *)name thumbnail:(UIImage *)thumbnail;
- (Pet *)missingPet;

@end
