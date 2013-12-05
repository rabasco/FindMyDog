//
//  AlertsViewController.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 03/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "ReportsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ReportStore.h"
#import "PetStore.h"

typedef enum { kMove, kFade  } AnimationType;

@interface ReportsViewController()
{
    CGPoint _imageCenter;
    NSString *_currentReportID;
}

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UIImageView *tickImage;
@property (nonatomic, weak) IBOutlet UIImageView *cancelImage;
@property (nonatomic, weak) IBOutlet UILabel *noAlertsLabel;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation ReportsViewController

- (void)viewDidLoad
{
    [self.image.layer setOpacity:0.0];
    [self.tickImage.layer setOpacity:0.0];
    [self.cancelImage.layer setOpacity:0.0];
    
    // Adjust image
    float height = [self.view bounds].size.height;
    float factor = 800 / height;
    float width = 600 / factor;
    
    [self.image setBounds:CGRectMake(0, 0, width, height)];
    _imageCenter = CGPointMake(self.view.bounds.size.width/2.0, height/2.0);
    
    [self.saveButton setTitle:[[NSString alloc] initWithFormat:@"Saved(%i)", [[[ReportStore defaultStore] savedReports] count]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLoadNextReport:)
                                                 name:@"ReportStoreDidLoadNextReportNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didNoPendingReports:)
                                                 name:@"ReportStoreNoPendingReportsNotification"
                                               object:nil];
    
    Pet *pet = [[PetStore defaultStore] missingPet];
    if (pet)
    {
        [self loadNextReport];
    }
}

- (void)loadNextReport
{
    NSString *title = [[NSString alloc] initWithFormat:@"It is %@?", [[[PetStore defaultStore] missingPet] name]];
    [self setTitle:title];
    
    [self.spinner startAnimating];
    [self.noAlertsLabel setHidden:YES];
    [self.toolbar setHidden:YES];
    
    [[ReportStore defaultStore] nextReport];
}

- (void)didLoadNextReport:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{

        _currentReportID = [[notification userInfo] objectForKey:@"reportID"];
        Report *report = [[[ReportStore defaultStore] pendingReports] objectForKey:_currentReportID];
        
        [self.image setImage:[report thumbnail]];
        [self.image setCenter:_imageCenter];
        
        [self.image.layer setOpacity:1.0f];
        
        [self.spinner stopAnimating];
        
        [self.toolbar setHidden:NO];
    });
}

- (void)didNoPendingReports:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.spinner stopAnimating];
        [self.noAlertsLabel setHidden:NO];
        [self.toolbar setHidden:YES];
    });
}

- (void)saveReportWithAnimation:(AnimationType)animationType
{
    CGPoint origin = [self.image center];
    CGPoint destination = [self.image center];
    destination.x = [self.image bounds].size.width * 1.5;
    
    if (animationType == kMove) {
        [self animateImageFrom:origin to:destination];
    }
    else if (animationType == kFade) {
        [self animateImageFade];
    }
    
    NSMutableDictionary *pendingReports = [[ReportStore defaultStore] pendingReports];
    NSMutableDictionary *savedReports = [[ReportStore defaultStore] savedReports];
    Report *reportToSave = [pendingReports objectForKey:_currentReportID];
    [reportToSave setPending:NO];
    [savedReports setObject:reportToSave forKey:_currentReportID];
    [pendingReports removeObjectForKey:_currentReportID];
    
    [self.saveButton setTitle:[[NSString alloc] initWithFormat:@"Saved(%i)", [[[ReportStore defaultStore] savedReports] count]]];
    
    [self loadNextReport];
}

- (void)discardReportWithAnimation:(AnimationType)animationType
{
    CGPoint origin = [self.image center];
    CGPoint destination = [self.image center];
    destination.x = -[self.image bounds].size.width;
    
    if (animationType == kMove) {
        [self animateImageFrom:origin to:destination];
    }
    else if (animationType == kFade) {
        [self animateImageFade];
    }
    
    [[ReportStore defaultStore] removeReportWithID:_currentReportID];
    
    [self loadNextReport];
}

- (void)animateTickCancelFadeOut
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    [self.tickImage.layer addAnimation:animation forKey:@"opacity"];
    [self.cancelImage.layer addAnimation:animation forKey:@"opacity"];
    [self.tickImage.layer setOpacity:0.0f];
    [self.cancelImage.layer setOpacity:0.0f];
}

- (void)animateImageFrom:(CGPoint)origin to:(CGPoint)destination
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.fromValue = [NSNumber valueWithCGPoint:origin];
    animation.toValue = [NSNumber valueWithCGPoint:destination];
    [self.image.layer addAnimation:animation forKey:@"position"];
    [self.image setCenter:destination];
}

- (void)animateImageFade
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    [self.image.layer addAnimation:animation forKey:@"opacity"];
    [self.image.layer setOpacity:0.0f];
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        [self.tickImage.layer setOpacity:1.0];
        [self.cancelImage.layer setOpacity:1.0];
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        [self animateTickCancelFadeOut];
        
        CGPoint center = [self.image center];
        
        if (center.x >= [self.image bounds].size.width)
        {
            [self saveReportWithAnimation:kMove];
            return;
        }
        
        if (center.x <= 0)
        {
            [self discardReportWithAnimation:kMove];
            return;
        }
        
        // Back to center
        [self animateImageFrom:[self.image center] to:_imageCenter];
    }
    else
    {
        CGPoint translation = [recognizer translationInView:self.view];
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.image];
        
        // Move tick and cancel images
        CGPoint tickCenter, cancelCenter;
        tickCenter = cancelCenter = self.image.center;
        tickCenter.x -= self.image.bounds.size.width/2.0 + 100.0;
        cancelCenter.x += self.image.bounds.size.width/2.0 + 100.0;
        [self.tickImage setCenter:tickCenter];
        [self.cancelImage setCenter:cancelCenter];
    }
}

- (IBAction)mapButtonPressed:(id)sender
{
    if ([[[ReportStore defaultStore] savedReports] count] > 0)
    {
        [self performSegueWithIdentifier:@"ReportMapSegue" sender:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Save an alert first"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)yesButtonPressed:(id)sender
{
    [self saveReportWithAnimation:kFade];
}

- (IBAction)noButtonPressed:(id)sender
{
    [self discardReportWithAnimation:kFade];
}


@end
