//
//  ExperthelloAppDelegate.h
//  Experthello
//
//  Created by Peter Wansch on 8/25/10.
//  Copyright Peter Wansch 2010, 2013. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface ExperthelloAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet MainViewController *mainViewController;

@end

