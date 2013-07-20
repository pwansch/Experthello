//
//  MainView.h
//  Experthello
//
//  Created by Peter Wansch on 8/25/10.
//  Copyright 2010, 2013 Peter Wansch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Algorithm.h"

@interface MainView : UIView

@property (assign, nonatomic) BOARD board;
@property (assign, nonatomic) BOOL fDisplayText;
@property (assign, nonatomic) short hintX;
@property (assign, nonatomic) short hintY;
@property (strong, nonatomic) NSString *statusText;

- (void)invalidateGameField:(short)sX :(short)sY;
- (void)invalidateText;
- (CGPoint)getTouchPosition:(NSSet *)touches;
- (short) makeMove:(short) sX :(short) sY :(short) sWho :(BOOL) fSimple :(BOOL) fInvalidate;

@end