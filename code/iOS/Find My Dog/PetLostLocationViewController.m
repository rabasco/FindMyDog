//
//  PetLostLocationViewController.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 10/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "PetLostLocationViewController.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PetStore.h"

@interface PetLostLocationViewController () <MKMapViewDelegate>
{
    CLLocationCoordinate2D _selectedLocation;
}

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end

@implementation PetLostLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.mapView setShowsUserLocation:YES];
    
    UITapGestureRecognizer *mapTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapHandler:)];
    [self.mapView addGestureRecognizer:mapTap];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _selectedLocation = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_selectedLocation, 250, 250);
    [self.mapView setRegion:region animated:YES];
}

-(void)mapTapHandler:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.mapView setShowsUserLocation:NO];
    
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    _selectedLocation = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    [self.mapView removeAnnotations:[self.mapView annotations]];
    
    MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
    pa.coordinate = _selectedLocation;
    [self.mapView addAnnotation:pa];

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_selectedLocation, 250, 250);
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)showCurrentLocation:(id)sender
{
    [self.mapView removeAnnotations:[self.mapView annotations]];
    [self.mapView setShowsUserLocation:YES];
}

- (IBAction)sendAlertButtonPressed:(id)sender
{
    [[PetStore defaultStore] missingPetWithID:[self.pet petID] lattitude:_selectedLocation.latitude longitude:_selectedLocation.longitude];
    
    // Back to MenuViewController
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
}

@end
