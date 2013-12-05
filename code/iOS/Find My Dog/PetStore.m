//
//  DataModel.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 14/09/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "PetStore.h"
#import "NetworkManager.h"

@implementation PetStore

static PetStore *defaultStore = nil;

- (id)init
{
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didLoadPets:)
                                                     name:@"NetworkManagerDidLoadPetsNotification"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didLoadPetImage:)
                                                     name:@"NetworkManagerDidLoadPetImageNotification"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didMissingPet:)
                                                     name:@"NetworkManagerDidMissingPetNotification"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didSavePet:)
                                                     name:@"NetworkManagerDidSavePetNotification"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didRemovePet:)
                                                     name:@"NetworkManagerDidRemovePetNotification"
                                                   object:nil];
        
        [self load];
    }
    
    return self;
}

+ (PetStore *)defaultStore
{
    if (defaultStore == nil) {
        defaultStore = [[super alloc] init];
    }
    
    return defaultStore;
}

- (void)load
{
    if (!pets) {
        // Load from local storage
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"Pet"];
        [request setEntity:e];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        
        if (result && [result count] > 0) {
            pets = [[NSMutableDictionary alloc] init];
            
            for (Pet *pet in result) {
                [pets setObject:pet forKey:[pet petID]];
            }
            
            // Send notification
            NSNotification *notif = [NSNotification notificationWithName:@"PetStoreDidLoadPetsNotification"
                                                                  object:self
                                                                userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notif];
        }
        else {
            // Load from server
            NetworkManager *proxy = [NetworkManager sharedNetworkManager];
            [proxy loadPets];
        }
    }
}

- (void)didLoadPets:(NSNotification *)notification
{
    pets = [[NSMutableDictionary alloc] init];
    
    NSDictionary *dict = [notification userInfo];
    NSArray *array = [dict objectForKey:@"array"];
    
    for (NSDictionary *item in array) {
        Pet *pet = [NSEntityDescription insertNewObjectForEntityForName:@"Pet"
                                                 inManagedObjectContext:context];
        
        [pet setPetID:[item objectForKey:@"id"]];
        [pet setName:[item objectForKey:@"name"]];
        
        NSString *missing = [item objectForKey:@"missing"];
        [pet setMissing:[missing boolValue]];
        
        if ([pet missing])
        {
            NSString *missingSince = [item objectForKey:@"missingSince"];
            [pet setMissingSince:[missingSince intValue]];
            
            NSArray *missingLocation = [item objectForKey:@"missingLocation"];
            
            NSNumber *longitude = [missingLocation objectAtIndex:0];
            [pet setMissingLongitude:[longitude doubleValue]];
            
            NSNumber *lattitude = [missingLocation objectAtIndex:1];
            [pet setMissingLattitude:[lattitude doubleValue]];
        }
        
        // Loading image
        NetworkManager *proxy = [NetworkManager sharedNetworkManager];
        [proxy loadPetImageWithId:pet.petID];
        
        [pets setObject:pet forKey:[pet petID]];
    }
    
    // Send notification
    NSNotification *notif = [NSNotification notificationWithName:@"PetStoreDidUpdateNotification"
                                                          object:self
                                                        userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

- (void)didLoadPetImage:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    NSString *petID = [dict objectForKey:@"petID"];
    NSData *imageData = [dict objectForKey:@"data"];
    
    Pet *pet = [pets objectForKey:petID];
    [pet setThumbnailData:imageData];
    [pet setThumbnail:[[UIImage alloc] initWithData:[pet thumbnailData]]];
    
    // Send notification
    NSNotification *notif = [NSNotification notificationWithName:@"PetStoreDidUpdateNotification"
                                                          object:self
                                                        userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

- (NSMutableDictionary *)pets
{
    return pets;
}

- (void)missingPetWithID:(NSString *)petID lattitude:(double)lattitude longitude:(double)longitude
{
    NetworkManager *proxy = [NetworkManager sharedNetworkManager];
    [proxy missingPetWithID:petID lattitude:lattitude longitude:longitude];
}

- (void)didMissingPet:(NSNotification *)notification
{
    NSString *petID = [[notification userInfo] objectForKey:@"petID"];
    double lattitude = [[[notification userInfo] objectForKey:@"lattitude"] doubleValue];
    double longitude = [[[notification userInfo] objectForKey:@"longitude"] doubleValue];
    
    Pet *pet = [pets objectForKey:petID];
    [pet setMissing:YES];
    [pet setMissingLattitude:lattitude];
    [pet setMissingLongitude:longitude];
}

- (Pet *)createPetWithName:(NSString *)name thumbnail:(UIImage *)thumbnail
{
    Pet *pet = [NSEntityDescription insertNewObjectForEntityForName:@"Pet"
                                             inManagedObjectContext:context];
    
    NSData *imageData = UIImageJPEGRepresentation(thumbnail, 90);
    
    [pet setPetID:@"temp"];
    [pet setName:name];
    [pet setMissing:NO];
    [pet setThumbnail:thumbnail];
    [pet setThumbnailData:imageData];
    
    NetworkManager *proxy = [NetworkManager sharedNetworkManager];
    [proxy savePetWithImageData:imageData name:name];
    
    [pets setObject:pet forKey:@"temp"];
    
    // Send notification
    NSNotification *notif = [NSNotification notificationWithName:@"PetStoreDidUpdateNotification"
                                                          object:self
                                                        userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
    
    return pet;
}

- (void)didSavePet:(NSNotification *)notification
{
    NSString *petID = [[notification userInfo] objectForKey:@"petID"];
    
    Pet *pet = [pets objectForKey:@"temp"];
    [pet setPetID:petID];
    [pets setObject:pet forKey:petID];
    [pets removeObjectForKey:@"temp"];
    
    // Send notification
    NSNotification *notif = [NSNotification notificationWithName:@"PetStoreDidUpdateNotification"
                                                          object:self
                                                        userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

- (void)setPetFoundWithID:(NSString *)petID
{
    Pet *pet = [pets objectForKey:petID];
    [pet setMissing:NO];
    
    NetworkManager *proxy = [NetworkManager sharedNetworkManager];
    [proxy foundPetWithID:petID];
    
    // Send notification
    NSNotification *notif = [NSNotification notificationWithName:@"PetStoreDidUpdateNotification"
                                                          object:self
                                                        userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

- (void)deletePetWithID:(NSString *)petID
{
    NetworkManager *proxy = [NetworkManager sharedNetworkManager];
    [proxy removePetWithId:petID];
}

- (void)didRemovePet:(NSNotification *)notification
{
    NSString *petID = [[notification userInfo] objectForKey:@"petID"];
    
    Pet *pet = [pets objectForKey:petID];
    [context deleteObject:pet];
    [pets removeObjectForKey:petID];
    
    // Send notification
    NSNotification *notif = [NSNotification notificationWithName:@"PetStoreDidUpdateNotification"
                                                          object:self
                                                        userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

- (Pet *)missingPet
{
    for (id key in pets) {
        Pet *pet = [pets objectForKey:key];
        
        if (pet.missing) {
            return pet;
        }
    }
    
    return nil;
}

@end
