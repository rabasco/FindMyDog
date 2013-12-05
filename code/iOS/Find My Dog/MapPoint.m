//
//  MapPoint.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 21/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapPoint.h"

@implementation MapPoint 

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)title
{
    self = [super init];
    if (self)
    {
        self.coordinate = coord;
        [self setTitle:title];
    }
    return self;
}

@end
