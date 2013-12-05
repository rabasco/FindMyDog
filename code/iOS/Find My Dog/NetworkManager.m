//
//  NetworkManager.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 17/06/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "NetworkManager.h"
#import "LoginRequest.h"
#import "SignUpRequest.h"
#import "SendReportRequest.h"
#import "LoadReportImageRequest.h"
#import "LoadReportsRequest.h"
#import "SavePetRequest.h"
#import "LoadPetsRequest.h"
#import "MissingPetRequest.h"
#import "LoadAlertRequest.h"
#import "FoundPetRequest.h"
#import "RemovePetRequest.h"

#import "LoadPetImageRequest.h"

@interface NetworkManager()
{
    NSOperationQueue *_networkQueue;
}

@end

@implementation NetworkManager

static NetworkManager *sharedNetworkManager = nil;

+ (NetworkManager *)sharedNetworkManager {
    if (sharedNetworkManager == nil)
    {
        sharedNetworkManager = [[super alloc] init];
    }
    return sharedNetworkManager;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _networkQueue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

- (void)loginWithEmail:(NSString *)email secret:(NSString *)secret
{
    [LoginRequest requestWithEmail:email secret:secret queue:_networkQueue];
}

- (void)signUpWithUsername:(NSString *)username email:(NSString *)email secret:(NSString *)secret
{
    [SignUpRequest requestWithUsername:username email:email secret:secret queue:_networkQueue];
}

- (void)sendReportWithImageData:(NSData *)imageData lattitude:(double)lattitude longitude:(double)longitude
{
    [SendReportRequest requestWithImageData:imageData lattitude:lattitude longitude:longitude queue:_networkQueue];
}

- (void)loadReportImageWithID:(NSString *)reportID;
{
    [LoadReportImageRequest requestWithID:reportID queue:_networkQueue];
}

- (void)loadReportsWithLattitude:(double)lattitude longitude:(double)longitude lastCheckTimestamp:(long)lastCheckTimestamp
{
    [LoadReportsRequest requestWithLattitude:lattitude longitude:longitude lastCheckTimestamp:lastCheckTimestamp queue:_networkQueue];
}

- (void)savePetWithImageData:(NSData *)data name:(NSString *)name
{
    [SavePetRequest requestWithImageData:data name:name queue:_networkQueue];
}

- (void)loadPets
{
    [LoadPetsRequest requestWithQueue:_networkQueue];
}

- (void)missingPetWithID:(NSString *)petID lattitude:(double)lattitude longitude:(double)longitude
{
    [MissingPetRequest requestWithPetId:petID lattitude:lattitude longitude:longitude queue:_networkQueue];
}

- (void)loadAlert
{
    [LoadAlertRequest requestWithQueue:_networkQueue];
}

- (void)foundPetWithID:(NSString *)petID;
{
    [FoundPetRequest requestWithPetID:petID queue:_networkQueue];
}

- (void)removePetWithId:(NSString *)petId
{
    [RemovePetRequest requestWithPetId:petId queue:_networkQueue];
}

- (void)loadPetImageWithId:(NSString *)petId
{
    [LoadPetImageRequest requestWithId:petId queue:_networkQueue];
}

@end
