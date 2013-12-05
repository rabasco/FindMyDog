//
//  RememberEmailViewController.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 14/11/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "RememberEmailViewController.h"

#define kOFFSET_FOR_KEYBOARD 60

@interface RememberEmailViewController () <UITextFieldDelegate>
{
    BOOL _keyboardInScreen;
}

@property (nonatomic, weak) IBOutlet UITextField *emailTextField;

@end

@implementation RememberEmailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _keyboardInScreen = NO;
}

- (IBAction)cancelButtonPressed:(id)sender
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController popViewControllerAnimated:NO];
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
        //[self.view endEditing:YES];
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
