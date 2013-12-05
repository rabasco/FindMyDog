//
//  AbstractStore.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 14/09/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "AbstractStore.h"

@implementation AbstractStore

static AbstractStore *defaultStore = nil;

+ (AbstractStore *)defaultStore
{
    if (defaultStore == nil)
    {
        defaultStore = [[super alloc] init];
    }
    
    return defaultStore;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        // Read FindMyDog.xcdatamodeld
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        // Where does the SQLite file go?
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        // Create the managed object context
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:psc];
        [context setUndoManager:nil];
    }
    
    return self;
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges
{
    NSError *err = nil;
    BOOL successful = [context save:&err];
    if (!successful) {
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    
    return successful;
}

- (void)reset
{
    [self deleteAllObjects:@"Configuration"];
    [self deleteAllObjects:@"Pet"];
    [self deleteAllObjects:@"Report"];
}

- (void)deleteAllObjects:(NSString *)entityDescription
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Tenemos %i elementos del tipo %@", [items count], entityDescription);
    for (NSManagedObject *managedObject in items) {
    	[context deleteObject:managedObject];
    	NSLog(@"%@ object deleted", entityDescription);
    }
    
    if (![context save:&error]) {
    	NSLog(@"Error deleting %@ - error:%@", entityDescription, error);
    }
}


@end
