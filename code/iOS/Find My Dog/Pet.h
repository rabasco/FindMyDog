//
//  Pet.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 16/09/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Pet : NSManagedObject

@property (nonatomic, retain) NSString * petID;
@property (nonatomic) BOOL missing;
@property (nonatomic) double missingLattitude;
@property (nonatomic) double missingLongitude;
@property (nonatomic) NSTimeInterval missingSince;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, strong) UIImage * thumbnail;
@property (nonatomic, retain) NSData * thumbnailData;

@end
