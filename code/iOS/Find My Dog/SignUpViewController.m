//
//  SignUpViewController.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 29/06/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "SignUpViewController.h"
#import "NetworkManager.h"
#import "Cryptoutil.h"

#define kOFFSET_FOR_KEYBOARD 80

@interface SignUpViewController() <UITextFieldDelegate>
{
    BOOL _keyboardInScreen;
}
@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSignUp:)
                                                 name:@"NetworkManagerDidSignUpNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSignUpError:)
                                                 name:@"NetworkManagerDidSignUpErrorNotification"
                                               object:nil];
    
    _keyboardInScreen = NO;
}
- (IBAction)cancelButtonPressed:(id)sender
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)saveButtonPressed:(id)sender
{
    NSString *username = [self.usernameTextField text];
    NSString *email = [self.emailTextField text];
    NSString *secret = [Cryptoutil sha1:[self.passwordTextField text]];
    
    // Check values
    if ([username length] == 0 || [email length] == 0 || [secret length] == 0)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                          message:@"Please, complete the fields."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    else
    {
        [self disableView];
        
        NetworkManager *proxy = [NetworkManager sharedNetworkManager];
        [proxy signUpWithUsername:username email:email secret:secret];
    }
}

- (void)didSignUp:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self enableView];
        
        [self cancelButtonPressed:nil];
    });
    
    NSNotification *notif = [NSNotification
                             notificationWithName:@"SignUpViewControllerDidLoginNotification"
                             object:self
                             userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

- (void)didSignUpError:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{

        [self enableView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Sign Up errror"
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!_keyboardInScreen) {
        [self setViewMovedUp:YES];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_keyboardInScreen) {
        //hides keyboard when another part of layout was touched
        [self.view endEditing:YES];
        //[super touchesBegan:touches withEvent:event];
        [self setViewMovedUp:NO];
    }
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
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

@end
