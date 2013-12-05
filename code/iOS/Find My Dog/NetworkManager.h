//
//  NetworkManager.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 17/06/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (NetworkManager *)sharedNetworkManager;

- (void)loginWithEmail:(NSString *)email secret:(NSString *)secret;
- (void)signUpWithUsername:(NSString *)username email:(NSString *)email secret:(NSString *)secret;
- (void)sendReportWithImageData:(NSData *)imageData lattitude:(double)lattitude longitude:(double)longitude;
- (void)loadReportImageWithID:(NSString *)reportID;
- (void)loadReportsWithLattitude:(double)lattitude longitude:(double)longitude lastCheckTimestamp:(long)lastCheckTimestamp;



// Meter pragmarks
- (void)savePetWithImageData:(NSData *)data name:(NSString *)name;
- (void)loadPets;


- (void)missingPetWithID:(NSString *)petID lattitude:(double)lattitude longitude:(double)longitude;
- (void)loadAlert;
- (void)foundPetWithID:(NSString *)petID;

- (void)removePetWithId:(NSString *)petId;

- (void)loadPetImageWithId:(NSString *)petId;

@end
