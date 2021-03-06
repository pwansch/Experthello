//
//  ExperthelloAppDelegate.m
//  Experthello
//
//  Created by Peter Wansch on 8/25/10.
//  Copyright Peter Wansch 2010, 2013. All rights reserved.
//

#import "ExperthelloAppDelegate.h"
#import "MainViewController.h"

@implementation ExperthelloAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Register default values
	NSString *versionValue = [[NSUserDefaults standardUserDefaults] stringForKey:kVersionKey];
	if (versionValue == nil)
	{			
		NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
									 @"1.2",  kVersionKey,
									 @"0",  kLevelKey,
									 @"YES",  kPlayerStartsKey,
									 @"YES", kSoundKey, nil];
		[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}

    // Add the main view controller's view to the window and display
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

@end
