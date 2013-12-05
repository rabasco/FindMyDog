//
//  Configuration.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 16/09/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Configuration : NSManagedObject

@property (nonatomic, retain) NSString * apikey;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSDate * lastReportsChecked;
@property (nonatomic, retain) NSString * secret;
@property (nonatomic, retain) NSString * username;

@end
