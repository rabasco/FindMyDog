//
//  BottonToTopSegue.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 16/11/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "BottomToTopSegue.h"

@implementation BottomToTopSegue

-(void)perform {
    
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    
    [sourceViewController.navigationController.view.layer addAnimation:transition
                                                                forKey:kCATransition];
    
    [sourceViewController.navigationController pushViewController:destinationController animated:NO];
}


@end
