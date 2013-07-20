//
//  ThreadInfo.h
//  Experthello
//
//  Created by Peter Wansch on 8/29/10.
//  Copyright 2010 Peter Wansch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Algorithm.h"

@interface ThreadInfo : NSObject

@property (assign, nonatomic) BOARD board;
@property (assign, nonatomic) BOOL pass;
@property (assign, nonatomic) BOOL hint;
@property (assign, nonatomic) short level;
@property (assign, nonatomic) short x;
@property (assign, nonatomic) short y;
@property (assign, nonatomic) BOOL valid;

@end
