//
//  LoginViewController.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 09/06/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//
#import <CoreImage/CoreImage.h>
#import "LoginViewController.h"
#import "ConfigurationStore.h"
#import "Cryptoutil.h"

#define kOFFSET_FOR_KEYBOARD 80

@interface LoginViewController () <UITextFieldDelegate>
{
    BOOL _keyboardInScreen;
}

@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, weak) IBOutlet UILabel *appNameLabel;
@property (nonatomic, weak) IBOutlet UIView *controlsView;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLogin:)
                                                 name:@"ConfigurationStoreDidLoginNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didError:)
                                                 name:@"ConfigurationStoreDidLoginErrorNotification"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLogin:)
                                                 name:@"SignUpViewControllerDidLoginNotification"
                                               object:nil];
    
    Configuration *config = [[ConfigurationStore defaultStore] configuration];
    
    // Complete fields
    [[self emailTextField] setText:[config email]];
    
    if ([[config apikey] length] > 0)
    {
        // Perform login
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
    
    [self runStartupAnimation];
    
    _keyboardInScreen = NO;
    
/*    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                      message:@"This windows will close in 2.5 seconds."
                                                     delegate:nil
                                            cancelButtonTitle:nil
                                            otherButtonTitles:nil];
    [message show];
    double delayInSeconds = 2.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [message dismissWithClickedButtonIndex:0 animated:YES];
    });*/
    
    
}

- (void) runStartupAnimation
{
    // App name animation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    CGPoint start = CGPointMake(160, 240);
    CGPoint end = CGPointMake(160, 150);
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    animation.fromValue = [NSNumber valueWithCGPoint:start];
    animation.toValue = [NSNumber valueWithCGPoint:end];
    animation.duration = 0.75;
    [self.appNameLabel.layer addAnimation:animation forKey:@"position"];
    
    // Controls animation
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fade setDelegate:self];
    [fade setBeginTime:CACurrentMediaTime()+0.25];
    [fade setRemovedOnCompletion:NO];
    [fade setFillMode:kCAFillModeForwards];
    fade.duration = 1.0;
    fade.fromValue = [NSNumber numberWithFloat:0.0];
    fade.toValue = [NSNumber numberWithFloat:1.0];
    
    [self.controlsView.layer addAnimation:fade forKey:@"opacity"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.controlsView.layer setOpacity:1.0];
    [self.appNameLabel.layer setPosition:CGPointMake(160, 150)];
}

-(IBAction)loginButtonPressed:(id)sender
{    
    NSString *email = [self.emailTextField text];
    NSString *secret = [Cryptoutil sha1:[self.passwordTextField text]];
    
    // Check email and password
    if ([email length] == 0 || [secret length] == 0) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                          message:@"Please, complete the fields."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    else
    {
        // Disable view
        [self disableView];
        
        // Login
        [[ConfigurationStore defaultStore] loginWithEmail:email secret:secret];
    }
}

- (void)didLogin:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self enableView];
        
        // Hide keyboard
        if (_keyboardInScreen) {
            [self setViewMovedUp:NO];
        }
        
        // Perform login
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    });
}

- (void)didError:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self enableView];
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Email or password invalid."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    });
}

- (void)enableView
{
    [[self view] setUserInteractionEnabled:YES];
    [self.spinner stopAnimating];
}

- (void)disableView
{
    [[self view] setUserInteractionEnabled:NO];
    [self.spinner startAnimating];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loginButtonPressed:nil];
    
    return YES;
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    _keyboardInScreen = movedUp;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
        
        [self.emailTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!_keyboardInScreen) {
        [self setViewMovedUp:YES];
    }
}

- (IBAction)signUpButtonPressed:(id)sender
{
    if (_keyboardInScreen) {
        [self setViewMovedUp:NO];
    }

    // Perform signUp
    [self performSegueWithIdentifier:@"signUpSegue" sender:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_keyboardInScreen) {
        //hides keyboard when another part of layout was touched
        [self.view endEditing:YES];
//        [super touchesBegan:touches withEvent:event];
        [self setViewMovedUp:NO];
    }
    
    
}

@end
