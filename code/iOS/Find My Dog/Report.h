//
//  Report.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 16/09/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Report : NSManagedObject

@property (nonatomic) NSTimeInterval created;
@property (nonatomic, retain) NSString * reportID;
@property (nonatomic) double lattitude;
@property (nonatomic) double longitude;
@property (nonatomic) BOOL pending;
@property (nonatomic, strong) UIImage * thumbnail;
@property (nonatomic, retain) NSData * thumbnailData;

@end
