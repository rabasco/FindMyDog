//
//  ConfigurationStore.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 14/09/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "ConfigurationStore.h"
#import "NetworkManager.h"

@implementation ConfigurationStore

static ConfigurationStore *defaultStore = nil;

- (id)init
{
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didLogin:)
                                                     name:@"NetworkManagerDidLoginNotification"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didLoginError:)
                                                     name:@"NetworkManagerLoginErrorNotification"
                                                   object:nil];
    }
    
    return self;
}

+ (ConfigurationStore *)defaultStore
{
    if (defaultStore == nil) {
        defaultStore = [[super alloc] init];
    }
    
    return defaultStore;
}

- (Configuration *)configuration
{
    if (!configuration) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"Configuration"];
        [request setEntity:e];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        if ([result count] > 0) {
            configuration = [result objectAtIndex:0];
        } else {
            configuration = [NSEntityDescription insertNewObjectForEntityForName:@"Configuration"
                                                          inManagedObjectContext:context];
        }
    }
    return configuration;
}

- (void)loginWithEmail:(NSString *)email secret:(NSString *)secret
{
    Configuration *config = [self configuration];
    [config setEmail:email];
    [config setSecret:secret];
    
    NetworkManager *proxy = [NetworkManager sharedNetworkManager];
    [proxy loginWithEmail:email secret:secret];
}

- (void)didLogin:(NSNotification *)notification
{
    NSString *apikey = [[notification userInfo] objectForKey:@"apikey"];
    
    Configuration *config = [self configuration];
    [config setApikey:apikey];
    
    // Send notification
    NSNotification *notif = [NSNotification notificationWithName:@"ConfigurationStoreDidLoginNotification"
                                                          object:self
                                                        userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

- (void)didLoginError:(NSNotification *)notification
{
    // Send notification
    NSNotification *notif = [NSNotification notificationWithName:@"ConfigurationStoreDidLoginErrorNotification"
                                                          object:self
                                                        userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

- (void)logout
{
    // Reset all data
    configuration = nil;
    [super reset];
}

@end
