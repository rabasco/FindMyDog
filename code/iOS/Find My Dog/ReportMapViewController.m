//
//  ReportMapViewController.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 17/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "ReportMapViewController.h"
#import <MapKit/MapKit.h>
#import "ReportStore.h"
#import "MapPoint.h"

@interface ReportMapViewController() <MKMapViewDelegate>
{
    CLLocationCoordinate2D _lastSelectedCoordinate;
}

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end

@implementation ReportMapViewController

- (void)viewDidLoad
{
    NSMutableDictionary *savedReports = [[ReportStore defaultStore] savedReports];
    NSArray *keys = [savedReports allKeys];
    
    Report *first = [savedReports objectForKey:[keys objectAtIndex:0]];
    _lastSelectedCoordinate = CLLocationCoordinate2DMake(first.lattitude, first.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_lastSelectedCoordinate, 10000, 10000);
    [self.mapView setRegion:region animated:YES];
    
    long current = [[NSDate date] timeIntervalSince1970];
    
    for (int i = 0; i < [keys count]; i++)
    {
        Report *report = [savedReports objectForKey:[keys objectAtIndex:i]];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(report.lattitude, report.longitude);
        
        long difference = current - report.created;
        int hours = difference / 3600;
        int minutes = difference % 3600 / 60;
        NSString *title = [[NSString alloc] initWithFormat:@"%d hours %d min ago", hours, minutes];
        
        MapPoint *mp = [[MapPoint alloc] initWithCoordinate:coord title:title];
        [self.mapView addAnnotation:mp];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MapPoint *mapPoint = (MapPoint *)view;
    _lastSelectedCoordinate = mapPoint.coordinate;
}

- (IBAction)goButtonPressed:(id)sender
{
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:_lastSelectedCoordinate
                                                   addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:@"Destination"];
    // Pass the map item to the Maps app
    [mapItem openInMapsWithLaunchOptions:nil];
}


@end
