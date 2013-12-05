//
//  PetDetailViewController.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 09/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "PetDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PetLostLocationViewController.h"
#import "PetCollectionViewController.h"
#import "PetStore.h"

@interface PetDetailViewController () <UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIView *petFrame;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *findBarButtonItem;

@end

@implementation PetDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.imageView setImage:[self.pet thumbnail]];
    [self.nameLabel setText:[self.pet name]];
    [self setTitle:[self.pet name]];
    
    if (self.pet.missing)
    {
        [self.findBarButtonItem setTitle:@"Found"];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PetLostLocationSegue"])
    {
        PetLostLocationViewController *controller = (PetLostLocationViewController *)segue.destinationViewController;
        controller.pet = self.pet;
    }
}

- (IBAction)findButtonPressed:(id)sender
{
    if ([self.pet missing])
    {
        [self petFound];
    }
    else
    {
        if ([[PetStore defaultStore] missingPet] == nil)
        {
            [self performSegueWithIdentifier:@"PetLostLocationSegue" sender:self];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                            message:@"Sorry, but you cannot find more than one dog."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)petFound
{
    [[PetStore defaultStore] setPetFoundWithID:[self.pet petID]];
    
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
}

- (IBAction)removePetButtonPressed:(id)sender
{
    if ([self.pet missing])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                        message:@"Sorry, but you cannot remove a lost pet."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Delete"
                                                  otherButtonTitles:nil];
        [sheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        [[PetStore defaultStore] deletePetWithID:[self.pet petID]];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
