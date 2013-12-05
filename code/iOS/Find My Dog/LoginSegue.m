//
//  LoginSegue.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 12/06/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "LoginSegue.h"

@implementation LoginSegue

-(void)perform {

    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 1.0;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromTop;

    [sourceViewController.navigationController.view.layer addAnimation:transition
                                                                forKey:kCATransition];
    
    [sourceViewController.navigationController pushViewController:destinationController animated:NO];
}

@end
