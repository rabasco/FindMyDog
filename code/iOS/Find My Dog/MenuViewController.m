//
//  MenuViewController.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 09/06/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "MenuViewController.h"

#import <CoreLocation/CoreLocation.h>
#import "ConfigurationStore.h"
#import "ReportStore.h"
#import "ImageUtil.h"

#define DURATION_EFFECT 1.0

@interface MenuViewController () <CLLocationManagerDelegate, UIActionSheetDelegate>
{
    CLLocationManager *_locationManager;
    CLLocation *_currentLocation;
}

@property (nonatomic, weak) IBOutlet UIView *cameraGroup;
@property (nonatomic, weak) IBOutlet UIView *alertsGroup;
@property (nonatomic, weak) IBOutlet UIView *petGroup;

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hide back button and show NavigationBar
    [[self navigationItem] setHidesBackButton:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self runAnimation];
}

- (void)runAnimation
{
    /*CGPoint origin;
    CGPoint destination;
    
    // Camera icon
    CABasicAnimation *cameraAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    origin = destination = [self.cameraGroup center];
    origin.y -= 300;
    [cameraAnimation setRemovedOnCompletion:NO];
    [cameraAnimation setFillMode:kCAFillModeForwards];
    cameraAnimation.fromValue = [NSNumber valueWithCGPoint:origin];
    cameraAnimation.toValue = [NSNumber valueWithCGPoint:destination];
    cameraAnimation.duration = DURATION_EFFECT;
    [self.cameraGroup.layer addAnimation:cameraAnimation forKey:@"position"];
    
    // Pets icon
    CABasicAnimation *petsAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    origin = destination = [self.petGroup center];
    origin.x -= 300;
    origin.y += 300;
    [petsAnimation setRemovedOnCompletion:NO];
    [petsAnimation setFillMode:kCAFillModeForwards];
    petsAnimation.fromValue = [NSNumber valueWithCGPoint:origin];
    petsAnimation.toValue = [NSNumber valueWithCGPoint:destination];
    petsAnimation.duration = DURATION_EFFECT;
    [self.petGroup.layer addAnimation:petsAnimation forKey:@"position"];
    
    // Alerts icon
    CABasicAnimation *alertsAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    origin = destination = [self.alertsGroup center];
    origin.x += 300;
    origin.y += 300;
    [alertsAnimation setRemovedOnCompletion:NO];
    [alertsAnimation setFillMode:kCAFillModeForwards];
    alertsAnimation.fromValue = [NSNumber valueWithCGPoint:origin];
    alertsAnimation.toValue = [NSNumber valueWithCGPoint:destination];
    alertsAnimation.duration = DURATION_EFFECT;
    [self.alertsGroup.layer addAnimation:alertsAnimation forKey:@"position"];*/
    
    self.cameraGroup.alpha = 0.0;
    self.alertsGroup.alpha = 0.0;
    self.petGroup.alpha = 0.0;
    
    CABasicAnimation *animationFade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animationFade.fromValue = [NSNumber numberWithFloat:0.0];
    animationFade.toValue = [NSNumber numberWithFloat:1.0];
    animationFade.duration = 0.5;
    animationFade.removedOnCompletion = NO;
    animationFade.fillMode = kCAFillModeForwards;
    
    animationFade.beginTime = CACurrentMediaTime() + 1.0;
    [self.cameraGroup.layer addAnimation:animationFade forKey:@"opacity"];
    
    animationFade.beginTime = CACurrentMediaTime() + 1.5;
    [self.alertsGroup.layer addAnimation:animationFade forKey:@"opacity"];
    
    animationFade.beginTime = CACurrentMediaTime() + 2.0;
    [self.petGroup.layer addAnimation:animationFade forKey:@"opacity"];
    
    double delayInSeconds = 2.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.cameraGroup.alpha = self.alertsGroup.alpha = self.petGroup.alpha = 1.0;
    });
}

- (IBAction)showCamera:(id)sender
{
    if (_locationManager == nil)
    {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    }
    
    _currentLocation = nil;
    [_locationManager startUpdatingLocation];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if ([image size].width > 800 || [image size].height > 600)
    {
        if ([image size].width > [image size].height)
        {
            image = [ImageUtil resizeImage:image toSize:CGSizeMake(800, 600)];
        }
        else {
            image = [ImageUtil resizeImage:image toSize:CGSizeMake(600, 800)];
        }
    }
    
    [[ReportStore defaultStore] sendReportWithImage:image lattitude:[_currentLocation coordinate].latitude longitude:[_currentLocation coordinate].longitude];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _currentLocation = [locations objectAtIndex:0];
    [_locationManager stopUpdatingLocation];
}

- (IBAction)showAccountMenu:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Close"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Logout", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) // Logout
    {
        [[ConfigurationStore defaultStore] logout];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
