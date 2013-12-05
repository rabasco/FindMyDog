//
//  RightToLeftSegue.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 15/11/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "RightToLeftSegue.h"

@implementation RightToLeftSegue

-(void)perform {
    
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    
    [sourceViewController.navigationController.view.layer addAnimation:transition
                                                                forKey:kCATransition];
    
    [sourceViewController.navigationController pushViewController:destinationController animated:NO];
}


@end
