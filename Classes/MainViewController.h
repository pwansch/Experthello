//
//  MainViewController.h
//  Experthello
//
//  Created by Peter Wansch on 8/25/10.
//  Copyright Peter Wansch 2010, 2013. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "Algorithm.h"
#import "ThreadInfo.h"
#import "InfoViewController.h"
#import "InfoViewController-iPad.h"

#define kVersionKey			@"version"
#define kLevelKey			@"level"
#define kPlayerStartsKey	@"playerStarts"
#define kSoundKey			@"sound"

@interface MainViewController : UIViewController <InfoViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *gameButton;
@property (strong, nonatomic) IBOutlet UIButton *hintButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) UIPopoverController *infoViewPopoverController;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (assign, nonatomic) SystemSoundID newId;
@property (assign, nonatomic) SystemSoundID hintId;
@property (assign, nonatomic) SystemSoundID passId;
@property (assign, nonatomic) SystemSoundID illegalId;
@property (assign, nonatomic) SystemSoundID placeId;
@property (assign, nonatomic) SystemSoundID drawId;
@property (assign, nonatomic) SystemSoundID lostId;
@property (assign, nonatomic) SystemSoundID wonId;
@property (assign, nonatomic) short m_level;
@property (assign, nonatomic) BOOL m_fPlayerStarts;
@property (assign, nonatomic) BOOL m_sound;
@property (assign, nonatomic) BOOL gameover;
@property (assign, nonatomic) BOOL threadRunning;

- (IBAction)showInfo:(id)sender;
- (IBAction)newGame:(id)sender;
- (IBAction)hintMove:(id)sender;
- (void)playSound:(SystemSoundID)soundID;
- (void)initializeGame;
- (void)moveComputed:(ThreadInfo *)threadInfo;
- (void)computeThread:(ThreadInfo *)threadInfo;

@end

