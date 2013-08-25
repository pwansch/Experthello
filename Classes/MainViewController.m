//
//  MainViewController.m
//  Experthello
//
//  Created by Peter Wansch on 8/25/10.
//  Copyright Peter Wansch 2010, 2013. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize gameButton;
@synthesize hintButton;
@synthesize infoButton;
@synthesize infoViewPopoverController;
@synthesize activityIndicator;
@synthesize newId;
@synthesize hintId;
@synthesize passId;
@synthesize illegalId;
@synthesize placeId;
@synthesize drawId;
@synthesize lostId;
@synthesize wonId;
@synthesize m_level;
@synthesize m_fPlayerStarts;
@synthesize m_sound;
@synthesize gameover;
@synthesize threadRunning;

// Implement viewDidLoad to do additional setup after loading the view
- (void)viewDidLoad {
	[super viewDidLoad];

	// Initialize the randomizer
	srandom(time(NULL));
    
    // Create system sounds
    NSString *path = [[NSBundle mainBundle] pathForResource:@"new" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &newId);
    path = [[NSBundle mainBundle] pathForResource:@"hint" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &hintId);
    path = [[NSBundle mainBundle] pathForResource:@"pass" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &passId);
    path = [[NSBundle mainBundle] pathForResource:@"illegal" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &illegalId);
    path = [[NSBundle mainBundle] pathForResource:@"place" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &placeId);
    path = [[NSBundle mainBundle] pathForResource:@"draw" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &drawId);
    path = [[NSBundle mainBundle] pathForResource:@"lost" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &lostId);
    path = [[NSBundle mainBundle] pathForResource:@"won" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &wonId);
    
    // Initialize settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.m_level = [defaults integerForKey:kLevelKey];
    self.m_fPlayerStarts = [defaults boolForKey:kPlayerStartsKey];
    self.m_sound = [defaults boolForKey:kSoundKey];

    // Hide the activity indicator
    self.activityIndicator.hidden = YES;

    // Initialize variables
    self.threadRunning = NO;
    [self initializeGame];
}

- (void)infoViewControllerDidFinish:(InfoViewController *)controller {
	// Save the settings
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	self.m_level = [defaults integerForKey:kLevelKey];
	self.m_fPlayerStarts = [defaults boolForKey:kPlayerStartsKey];
	self.m_sound = [defaults boolForKey:kSoundKey];
	
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.infoViewPopoverController dismissPopoverAnimated:YES];
    }
}

- (IBAction)showInfo:(id)sender {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        InfoViewController *controller = [[InfoViewController alloc] initWithNibName:@"InfoView" bundle:nil];
        controller.delegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        if (!self.infoViewPopoverController) {
            InfoViewController *controller = [[InfoViewController alloc] initWithNibName:@"InfoView" bundle:nil];
            controller.delegate = self;
            
            self.infoViewPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
        }
        if ([self.infoViewPopoverController isPopoverVisible]) {
            [self.infoViewPopoverController dismissPopoverAnimated:YES];
        } else {
            [self.infoViewPopoverController presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}

- (IBAction)newGame:(id)sender {  
	[self initializeGame];
}

- (IBAction)hintMove:(id)sender {
    MainView *mainView = (MainView *)self.view;

    if(!self.gameover && !self.threadRunning) {
        // User requests a hint
        BOARD boardHilf;
        BOARD boardThreadHilf;
        for(short sX = 0; sX < 8; sX++)
            for(short sY = 0; sY < 8; sY++)
            {
                switch(mainView.board.sField[sX][sY])
                {
                    case COMPUTER:
                        boardHilf.sField[sX][sY] = PLAYER;
                        break;
                            
                    case PLAYER:
                        boardHilf.sField[sX][sY] = COMPUTER;
                        break;
                            
                    default:
                        boardHilf.sField[sX][sY] = EMPTY;
                        break;
                }
            }
            
        // Computer makes a move
        ThreadInfo *threadInfo = [ThreadInfo alloc];
        CopyBoard(boardHilf, &boardThreadHilf);
        threadInfo.board = boardThreadHilf;
        threadInfo.pass = NO;
        threadInfo.hint = YES;
        threadInfo.level = self.m_level;
        self.threadRunning = YES;
        if (self.m_level > 0) {
            [self.activityIndicator startAnimating];
        }
        [self computeThread:threadInfo];
    }
    else {
        // Unable to show hint
        [self playSound:illegalId];
    }
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
	// Release any retained subviews of the main view
	self.gameButton = nil;
	self.hintButton = nil;
    self.infoButton = nil;
    self.infoViewPopoverController = nil;
    self.activityIndicator = nil;
    
    // Dispose sounds
    AudioServicesDisposeSystemSoundID(newId);
    AudioServicesDisposeSystemSoundID(hintId);
    AudioServicesDisposeSystemSoundID(passId);
    AudioServicesDisposeSystemSoundID(illegalId);
    AudioServicesDisposeSystemSoundID(placeId);
    AudioServicesDisposeSystemSoundID(drawId);
    AudioServicesDisposeSystemSoundID(lostId);
    AudioServicesDisposeSystemSoundID(wonId);
}

- (void) playSound:(SystemSoundID)soundID {
	if (self.m_sound) {
		AudioServicesPlaySystemSound(soundID);
	}
}

- (void)initializeGame {
    MainView *mainView = (MainView *)self.view;
    
	// Do not accept input while a move is being computed
	if(self.threadRunning) {
		[self playSound:illegalId];
		return;
	}
	
	// Play the new game sound
	[self playSound:newId];
	
	// Initialize the game
    BOARD boardHilf;
	self.gameover = NO;
	for(short sX = 0; sX < DIVISIONS; sX++)
		for(short sY = 0; sY < DIVISIONS; sY++)
			boardHilf.sField[sX][sY] = EMPTY;
	boardHilf.sField[3][3] = PLAYER;
	boardHilf.sField[4][4] = PLAYER;
	boardHilf.sField[3][4] = COMPUTER;
	boardHilf.sField[4][3] = COMPUTER;
    mainView.board = boardHilf;
    
	// If the player starts, make a move
	mainView.fDisplayText = YES;
	if(!self.m_fPlayerStarts)
	{
		mainView.statusText = [[NSString alloc] initWithFormat: @""];
		
		// Computer macht einen zug
        BOARD boardThreadHilf;
		ThreadInfo *threadInfo = [ThreadInfo alloc];
		CopyBoard(mainView.board, &boardThreadHilf);
        threadInfo.board = boardThreadHilf;
		threadInfo.pass = NO;
		threadInfo.hint = NO;
		threadInfo.level = self.m_level;
		self.threadRunning = YES;
		if (self.m_level > 0) {
			[self.activityIndicator startAnimating];
		}
		[self computeThread:threadInfo];
	}
	else {
		mainView.statusText = [[NSString alloc] initWithFormat: @"You play blue."];
	}
	
	// Draw the view
	[mainView setNeedsDisplay];
}

- (void)moveComputed:(ThreadInfo *)threadInfo {
    MainView *mainView = (MainView *)self.view;
    
	// The move was computed in the background
	short sX = threadInfo.x;
	short sY = threadInfo.y;
	
	// Declare local variables
	short sComputer, sPlayer;
	
	if (mainView.fDisplayText)
	{
		// Erase text
		mainView.fDisplayText = NO;
		[mainView invalidateText];
	}
	
	if(threadInfo.hint)
	{
		// Play a hint sound
		[self playSound:hintId];
		
		// Move mouse pointer to recommended position
		mainView.hintX = sX;
		mainView.hintY = sY;
		[mainView setNeedsDisplay];
	}
	else
	{
		// Computer move machen
		[self playSound:placeId];
		[mainView makeMove:sX :sY :COMPUTER :TRUE :TRUE];
		
		// Ist das spiel schon vorbei?
		if (fGameOver(mainView.board))
		{
			// Spiel ist vorbei
			self.gameover = TRUE;
			Result(mainView.board, &sComputer, &sPlayer);
			
			if(sComputer == sPlayer)
			{
				// Das spiel ist unentschieden
				[self playSound:drawId];
				mainView.statusText = [[NSString alloc] initWithFormat: @"The game is a draw."];
			}
			else
			{
				if(sComputer > sPlayer)
				{
					// Computer won
					[self playSound:lostId];
					mainView.statusText = [[NSString alloc] initWithFormat: @"Computer won."];
				}
				else
				{
					// Player won
					[self playSound:wonId];
					mainView.statusText = [[NSString alloc] initWithFormat: @"You won."];
				}
			}
			
			// Textbereich updaten
            mainView.fDisplayText = TRUE;
			[mainView invalidateText];
		}
		else
		{
			if (fMustPass(mainView.board, PLAYER)) // muss der player passen
			{
				[self playSound:passId];
				mainView.fDisplayText = TRUE;
				mainView.statusText = [[NSString alloc] initWithFormat: @"You must pass..."];
				[mainView invalidateText];
                
				// Computer macht einen zug
				ThreadInfo *threadInfo = [ThreadInfo alloc];
                BOARD boardThreadHilf;
				CopyBoard(mainView.board, &boardThreadHilf);
                threadInfo.board = boardThreadHilf;
				threadInfo.pass = YES;
				threadInfo.hint = NO;
				threadInfo.level = self.m_level;
				self.threadRunning = YES;
				if (self.m_level > 0) {
					[self.activityIndicator startAnimating];
				}
				[self computeThread:threadInfo];
			}
		}
	}
	
	// Indicate that the thread is no longer running and stop animating
	[self.activityIndicator stopAnimating];
	self.threadRunning = NO;
}

- (void)computeThread:(ThreadInfo *)threadInfo {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        short sX, sY;
        BOOL valid;
        
        // Compute the move
        if (threadInfo.pass)
            [NSThread sleepForTimeInterval:2];
        
        // Move computation
        sOthello(threadInfo.board, 0, 0, 0, threadInfo.level + 3, COMPUTER, &sX, &sY, &valid, 0);
        
        // Set the output variables
        threadInfo.x = sX;
        threadInfo.y = sY;
        threadInfo.valid = valid;
        
        // Call the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [self moveComputed:threadInfo];
        });
    });
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    MainView *mainView = (MainView *)self.view;
    
	// Do not accept input while a move is being computed
	if(self.threadRunning) {
		[self playSound:illegalId];
		return;
	}
	
	// Declare local variables
	short sComputer, sPlayer;
	
	if (!self.gameover)
	{
        // Get touch position
        CGPoint point = [mainView getTouchPosition:touches];
		
		// Jetzt haben wir den point und machen einen Zug mit point.x und point.y
		if (mainView.fDisplayText)
		{
			// erase text
			mainView.fDisplayText = NO;
			[mainView invalidateText];
		}
		
		// Schauen ob der zeiger am spielbrett ist
		if (point.x == 0 || point.y == 0 || point.x == (DIVISIONS + 1) || point.y == (DIVISIONS + 1)) {
			// Zeiger ist nicht am spielbrett
			[self playSound:illegalId];
		}
		else
		{
			// Zeiger ist am spielbrett
			// Wechseln in spiel koordinaten
			point.x--;
			point.y = DIVISIONS - point.y;
			if(!fIsMovePossible(mainView.board, (short)point.x, (short)point.y, PLAYER)) {
				// Zug ist ungueltig
				[self playSound:illegalId];
				fIsMovePossible(mainView.board, (short)point.x, (short)point.y, PLAYER);
			}
			else
			{
				// Zug ist gueltig
				[self playSound:placeId];
                [mainView makeMove:(short)point.x :(short)point.y :PLAYER :TRUE :TRUE];
				
				// Ist das spiel schon vorbei?
				if (fGameOver(mainView.board))
				{
					// Spiel ist vorbei
					self.gameover = TRUE;
					Result(mainView.board, &sComputer, &sPlayer);
					
					if(sComputer == sPlayer)
					{
						// Das spiel ist unentschieden
						[self playSound:drawId];
						mainView.statusText = [[NSString alloc] initWithFormat: @"The game is a draw."];
					}
					else
					{
						if(sComputer > sPlayer)
						{
							// Computer won
							[self playSound:lostId];
							mainView.statusText = [[NSString alloc] initWithFormat: @"Computer won."];
						}
						else
						{
							// Player won
							[self playSound:wonId];
							mainView.statusText = [[NSString alloc] initWithFormat: @"You won."];
						}
					}
					
					// Textbereich updaten
                    mainView.fDisplayText = TRUE;
					[mainView invalidateText];
				}
				else
				{
					if (fMustPass(mainView.board, COMPUTER)) // muss der computer oder gegner passen
					{
						[self playSound:passId];
						mainView.fDisplayText = TRUE;
						mainView.statusText = [[NSString alloc] initWithFormat: @"Computer must pass..."];
						[mainView invalidateText];
					}
					else
					{
						// Computer macht einen zug
						ThreadInfo *threadInfo = [ThreadInfo alloc];
                        BOARD boardThreadHilf;
						CopyBoard(mainView.board, &boardThreadHilf);
                        threadInfo.board = boardThreadHilf;
						threadInfo.pass = NO;
						threadInfo.hint = NO;
						threadInfo.level = self.m_level;
						self.threadRunning = YES;
						if (self.m_level > 0) {
							[self.activityIndicator startAnimating];
						}
						[self computeThread:threadInfo];
					}
				}
			}
		}
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return (interfaceOrientation !=	UIInterfaceOrientationPortraitUpsideDown);
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // Dismiss popover if it is displayed
    if (self.infoViewPopoverController != nil) {
        [self.infoViewPopoverController dismissPopoverAnimated:YES];
    }
    
    // Change the location of the buttons
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        gameButton.frame = CGRectMake(20, self.view.bounds.size.height - 82, 90, 30);
        hintButton.frame = CGRectMake(20, self.view.bounds.size.height - 47, 90, 30);
    } else {
        gameButton.frame = CGRectMake(20, self.view.bounds.size.height - 47, 90, 30);
        hintButton.frame = CGRectMake(118, self.view.bounds.size.height - 47, 60, 30);
    }
}

@end
