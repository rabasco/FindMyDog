//
//  Pet.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 16/09/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "Pet.h"


@implementation Pet

@dynamic petID;
@dynamic missing;
@dynamic missingLattitude;
@dynamic missingLongitude;
@dynamic missingSince;
@dynamic name;
@dynamic thumbnail;
@dynamic thumbnailData;

- (void)awakeFromFetch
{
    [super awakeFromFetch];
    
    UIImage *thumbnail = [UIImage imageWithData:[self thumbnailData]];
    [self setPrimitiveValue:thumbnail forKey:@"thumbnail"];
}

@end
