//
//  InfoViewController.h
//  Experthello
//
//  Created by Peter Wansch on 8/25/10.
//  Copyright Peter Wansch 2010, 2013. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfoViewController;

@protocol InfoViewControllerDelegate
- (void)infoViewControllerDidFinish:(InfoViewController *)controller;
@end

@interface InfoViewController : UIViewController

@property (weak, nonatomic) id <InfoViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UISwitch *playerStartsSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (strong, nonatomic) IBOutlet UISegmentedControl *levelControl;
@property (strong, nonatomic) IBOutlet UITextView *textView;

- (IBAction)done:(id)sender;

@end

