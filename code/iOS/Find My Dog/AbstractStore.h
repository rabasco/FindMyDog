//
//  AbstractStore.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 14/09/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface AbstractStore : NSObject
{
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

+ (AbstractStore *)defaultStore;

- (BOOL)saveChanges;
- (void)reset;

@end
