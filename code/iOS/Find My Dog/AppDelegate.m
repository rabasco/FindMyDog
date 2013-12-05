//
//  AppDelegate.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 09/06/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "AppDelegate.h"
#import "ConfigurationStore.h"
#import "PetStore.h"
#import "ReportStore.h"

@interface AppDelegate ()
{
    
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    UIImage *backgroundImage = [UIImage imageNamed:@"blur_main_bg"];
    [backgroundView setImage:backgroundImage];
    [self.window insertSubview:backgroundView atIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLogin:)
                                                 name:@"ConfigurationStoreDidLoginNotification"
                                               object:nil];
    
    return YES;
}

- (void)didLogin:(NSNotification *)notification
{
//    UIImageView *backgroundView = [[self.window subviews] objectAtIndex:0];
//    [backgroundView removeFromSuperview];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    UIImage *backgroundImage = [UIImage imageNamed:@"blur_main_bg"];
    [backgroundView setImage:backgroundImage];
    [self.window insertSubview:backgroundView atIndex:1];
    
    
 /*   UIImage *backgroundImage = [UIImage imageNamed:@"blur_main_bg"];
    UIImageView *backgroundView = [[self.window subviews] objectAtIndex:0];
    [backgroundView setImage:backgroundImage];
    [self.window setNeedsDisplay];*/
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if([[ConfigurationStore defaultStore] saveChanges])
    {
        NSLog(@"Configuration saved");
    }
    else
    {
        NSLog(@"Error saving configuration");
    }
    
    if([[PetStore defaultStore] saveChanges])
    {
        NSLog(@"Pets saved");
    }
    else
    {
        NSLog(@"Error saving pets");
    }
    
    if([[ReportStore defaultStore] saveChanges])
    {
        NSLog(@"Reports saved");
    }
    else
    {
        NSLog(@"Error saving reports");
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
