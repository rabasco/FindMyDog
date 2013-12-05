//
//  ConfigurationStore.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 14/09/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractStore.h"
#import "Configuration.h"

@interface ConfigurationStore : AbstractStore
{
    Configuration *configuration;
}

+ (ConfigurationStore *)defaultStore;

- (Configuration *)configuration;
- (void)loginWithEmail:(NSString *)email secret:(NSString *)secret;
- (void)logout;

@end
