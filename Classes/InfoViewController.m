//
//  InfoViewController.m
//  Experthello
//
//  Created by Peter Wansch on 8/25/10.
//  Copyright Peter Wansch 2010, 2013. All rights reserved.
//

#import "InfoViewController.h"
#import "MainViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    }
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	// Load settings
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	self.playerStartsSwitch.on = [defaults boolForKey:kPlayerStartsKey];
	self.soundSwitch.on = [defaults boolForKey:kSoundKey];
	self.levelControl.selectedSegmentIndex = [defaults integerForKey:kLevelKey];
}

- (IBAction)done:(id)sender {
	// Save settings and write to disk
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	[defaults setBool:self.playerStartsSwitch.on forKey:kPlayerStartsKey];
	[defaults setBool:self.soundSwitch.on forKey:kSoundKey];
	[defaults setInteger:self.levelControl.selectedSegmentIndex forKey:kLevelKey];
	[defaults synchronize];	
	[self.delegate infoViewControllerDidFinish:self];	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view
	self.playerStartsSwitch = nil;
	self.soundSwitch = nil;
	self.levelControl = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return (interfaceOrientation !=	UIInterfaceOrientationPortraitUpsideDown);
    }
}

@end
