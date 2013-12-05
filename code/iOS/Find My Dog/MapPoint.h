//
//  MapPoint.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 21/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapPoint : NSObject <MKAnnotation>
{
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)title;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

@end
