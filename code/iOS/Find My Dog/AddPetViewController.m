//
//  AddPetViewController.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 07/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "AddPetViewController.h"
#import "PetStore.h"

#define kOFFSET_FOR_KEYBOARD 170.0

@interface AddPetViewController()
{
    BOOL _keyboardInScreen;
}

@property (nonatomic, weak) IBOutlet UIImageView *petImage;
@property (nonatomic, weak) IBOutlet UITextField *petNameTextField;

@end

@implementation AddPetViewController

- (void)viewDidLoad
{
    _keyboardInScreen = NO;
    [self performSelector:@selector(showImagePicker) withObject:nil afterDelay:0.1];
}

- (void)showImagePicker
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setAllowsEditing:YES];
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.petImage setImage:image];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{[self popViewController];}];
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
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setViewMovedUp:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self setViewMovedUp:NO];
    [self.petNameTextField resignFirstResponder];
    return NO;
}

- (IBAction)saveButtonPressed:(id)sender
{
    if ([self.petNameTextField.text length] == 0)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                          message:@"Please, complete pet's name."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    else
    {
        [[PetStore defaultStore] createPetWithName:[self.petNameTextField text]
                                         thumbnail:[self.petImage image]];
        
        if (_keyboardInScreen)
        {
            [self textFieldShouldReturn:nil];
        }
        
        [self performSelector:@selector(popViewController) withObject:nil afterDelay:0.5];
    }
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
