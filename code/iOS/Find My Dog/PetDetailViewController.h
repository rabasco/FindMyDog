//
//  PetDetailViewController.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 09/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pet.h"

@interface PetDetailViewController : UIViewController

@property (nonatomic, strong) Pet *pet;

- (IBAction)findButtonPressed:(id)sender;
- (IBAction)removePetButtonPressed:(id)sender;

@end
