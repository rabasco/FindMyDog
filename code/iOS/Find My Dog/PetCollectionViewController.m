//
//  PetCollectionViewController.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 08/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "PetCollectionViewController.h"
#import "PetStore.h"
#import "PetDetailViewController.h"

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

@interface PetCollectionViewController ()
{
    PetStore *_petStore;
    Pet *_selectedPet;
}

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation PetCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _petStore = [PetStore defaultStore];[self.collectionView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshPetCollection:)
                                                 name:@"PetStoreDidUpdateNotification"
                                               object:nil];
}

- (void)refreshPetCollection:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[_petStore pets] count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"PetCell";
    
    NSArray *keys = [[_petStore pets] allKeys];
    
    Pet *pet = [[_petStore pets] objectForKey:[keys objectAtIndex:indexPath.row]];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (pet.thumbnail != nil)
    {
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
        imageView.image = pet.thumbnail;
        
        // Mask
        CALayer *imageLayer = imageView.layer;
        [imageLayer setCornerRadius:imageView.frame.size.width/2];
        [imageLayer setBorderWidth:3];
        [imageLayer setBorderColor:[[UIColor whiteColor] CGColor]];
        [imageLayer setMasksToBounds:YES];
        
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[cell viewWithTag:120];
        [spinner stopAnimating];
        [cell setUserInteractionEnabled:YES];
        
        if ([pet missing]) {
            UILabel *lostLabel = (UILabel *)[cell viewWithTag:130];
            [lostLabel setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-45))];
            [lostLabel setHidden:FALSE];
        } else {
            UILabel *lostLabel = (UILabel *)[cell viewWithTag:130];
            [lostLabel setHidden:TRUE];
        }
    }
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:110];
    nameLabel.text = pet.name;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *keys = [[_petStore pets] allKeys];
    
    _selectedPet = [[_petStore pets] objectForKey:[keys objectAtIndex:indexPath.row]];
    
    [self performSegueWithIdentifier:@"PetDetailSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"PetDetailSegue"])
    {
        PetDetailViewController *controller = (PetDetailViewController *)segue.destinationViewController;
        controller.pet = _selectedPet;
    }
}

@end
