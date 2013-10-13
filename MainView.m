//
//  MainView.m
//  Experthello
//
//  Created by Peter Wansch on 8/25/10.
//  Copyright 2010, 2013 Peter Wansch. All rights reserved.
//

#import "MainView.h"
#import "Algorithm.h"

// Prototype from Algorithm.m
short MakeMove(PBOARD pBoard, short sX, short sY, short sWho, BOOL fSimple, BOOL fInvalidate, MainView *mainView);

@implementation MainView

@synthesize board;
@synthesize fDisplayText;
@synthesize statusText;
@synthesize hintX;
@synthesize hintY;

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super initWithCoder:coder]))
	{
		// Initialize variables
		self.hintX = -1;
		self.hintY = -1;
        self.fDisplayText = NO;
		
		// Set the background color of the view
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.5f blue:0.0f alpha:1.0f];
	}
    return self;
}

- (void)drawRect:(CGRect)rect {
	// Calculate block size, starting point and offset
	CGFloat m_block = MIN(self.bounds.size.width / (DIVISIONS + 2), self.bounds.size.height / (DIVISIONS + 2));
	CGPoint m_point = CGPointMake((self.bounds.size.width - (m_block * DIVISIONS)) / 2, (self.bounds.size.height - (m_block * DIVISIONS)) / 2);
	CGFloat offset = m_block / 6;
	
	// Obtain graphics context and set defaults
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 1.0); 
	
	// Light gray board is drawn
	CGRect rectPaint = CGRectMake(m_point.x, m_point.y, DIVISIONS * m_block, DIVISIONS * m_block);
	CGRect rectIntersect = CGRectIntersection(rectPaint, rect);
	if (!CGRectIsNull(rectIntersect)) {
		CGContextAddRect(context, rectIntersect);
		CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
		CGContextDrawPath(context, kCGPathFill);
	}
	
	// Draw empty squares
	CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
	for (short x = 0; x < DIVISIONS; x++) {
		for (short y = 0; y < DIVISIONS; y++) {
			rectPaint = CGRectMake(m_point.x + (x * m_block), m_point.y + ((DIVISIONS - y - 1) * m_block),
								   m_block, m_block);			
			if (CGRectIntersectsRect(rectPaint, rect)) {
				CGContextAddRect(context, rectPaint);
				CGContextStrokePath(context);
			}
		}
	}
	
	// Draw board borders
	CGContextSetFillColorWithColor(context, [UIColor darkGrayColor].CGColor);
	
	// Lower border
	CGPoint pointBorder[4];
	pointBorder[0].x = m_point.x;
	pointBorder[0].y = m_point.y + (DIVISIONS * m_block);
	pointBorder[1].x = m_point.x + (DIVISIONS * m_block) + 1;
	pointBorder[1].y = pointBorder[0].y;
	pointBorder[2].x = pointBorder[1].x + offset;
	pointBorder[2].y = pointBorder[1].y + offset;
	pointBorder[3].x = pointBorder[0].x + offset;
	pointBorder[3].y = pointBorder[0].y + offset;
	rectPaint = CGRectMake(pointBorder[0].x, pointBorder[0].y, (DIVISIONS * m_block) + 1 + offset, offset); 
	if (CGRectIntersectsRect(rectPaint, rect)) {
		CGContextAddLines(context, pointBorder, 4);
		CGContextClosePath(context);	
		CGContextDrawPath(context, kCGPathFillStroke);
	}
	
	// Right border
	pointBorder[0].x = m_point.x + (DIVISIONS * m_block);
	pointBorder[0].y = m_point.y - 1;
	pointBorder[1].x = m_point.x + (DIVISIONS * m_block);
	pointBorder[1].y = m_point.y + (DIVISIONS * m_block);
	pointBorder[2].x = pointBorder[1].x + offset;
	pointBorder[2].y = pointBorder[1].y + offset;
	pointBorder[3].x = pointBorder[0].x + offset;
	pointBorder[3].y = pointBorder[0].y + offset;
	rectPaint = CGRectMake(pointBorder[0].x, pointBorder[0].y, offset, (DIVISIONS * m_block) + offset); 
	if (CGRectIntersectsRect(rectPaint, rect)) {
		CGContextAddLines(context, pointBorder, 4);
		CGContextClosePath(context);	
		CGContextDrawPath(context, kCGPathFillStroke);
	}

	// Draw shadows
	CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
	
	// Draw lower shadow
	rectPaint = CGRectMake(m_point.x + (2 * offset), m_point.y + (DIVISIONS * m_block) + offset, (DIVISIONS * m_block) + offset, (2 * offset));
	if (CGRectIntersectsRect(rectPaint, rect)) {
		CGContextAddRect(context, rectPaint);
		CGContextDrawPath(context, kCGPathFill);
	}
		
	// Draw right shadow
	rectPaint = CGRectMake(m_point.x + (DIVISIONS * m_block) + offset, m_point.y + (2 * offset), (2 * offset), (DIVISIONS * m_block));
	if (CGRectIntersectsRect(rectPaint, rect)) {
		CGContextAddRect(context, rectPaint);
		CGContextDrawPath(context, kCGPathFill);
	}

	// Draw game stones
	for (short x = 0; x < DIVISIONS; x++) {
		for (short y = 0; y < DIVISIONS; y++)
		{
			if (self.board.sField[x][y] != EMPTY)
			{
				switch (self.board.sField[x][y])
				{
					case COMPUTER:
						CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor); 
						break;
					case PLAYER: 
						CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
						break;
				}

				rectPaint = CGRectMake(m_point.x + (x * m_block) + offset, m_point.y + ((DIVISIONS - y - 1) * m_block) + offset, m_block - (2 * offset), m_block - (2 * offset));
				if (CGRectIntersectsRect(rectPaint, rect)) {
					CGContextAddEllipseInRect(context, rectPaint);
					CGContextDrawPath(context, kCGPathFillStroke);
				}
			}
		}
	}
	
	// Draw hint
	if (self.hintX >= 0 && self.hintY >= 0){
		rectPaint = CGRectMake(m_point.x + (self.hintX * m_block) + offset, m_point.y + ((DIVISIONS - self.hintY - 1) * m_block) + offset, m_block - (2 * offset), m_block - (2 * offset));
		CGContextAddEllipseInRect(context, rectPaint);
		CGContextDrawPath(context, kCGPathStroke);
		self.hintX = -1;
		self.hintY = -1;
	}
	
	// Draw text
    UIFont *font;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        font = [UIFont systemFontOfSize:14];
    } else {
        font = [UIFont systemFontOfSize:28];
    }
	rectPaint = CGRectMake(0, (m_point.y - font.pointSize / 2) / 2, (2 * m_point.x) + (DIVISIONS * m_block), m_point.y);
	if (self.fDisplayText && CGRectIntersectsRect(rectPaint, rect))
	{
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *dictionaryWhite = @{NSFontAttributeName: font,  NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: [UIColor whiteColor]};
        [self.statusText drawInRect:rectPaint withAttributes:dictionaryWhite];
	}
}

- (short) makeMove:(short) sX :(short) sY :(short) sWho :(BOOL) fSimple :(BOOL) fInvalidate {
    return MakeMove(&board, sX, sY, sWho, fSimple, fInvalidate, self);
}

- (void)invalidateGameField:(short)x :(short)y {
	// Calculate block size, starting point
	CGFloat m_block = MIN(self.bounds.size.width / (DIVISIONS + 2), self.bounds.size.height / (DIVISIONS + 2));
	CGPoint m_point = CGPointMake((self.bounds.size.width - (m_block * DIVISIONS)) / 2, (self.bounds.size.height - (m_block * DIVISIONS)) / 2);
	
	// Invalidate the button
	CGRect rectUpdate = CGRectMake(m_point.x + (x * m_block) + 1, m_point.y + ((DIVISIONS - y - 1) * m_block) + 1, m_block - 2, m_block - 2);
	[self setNeedsDisplayInRect:rectUpdate];
}

- (void)invalidateText {
	// Calculate block size, starting point
	CGFloat m_block = MIN(self.bounds.size.width / (DIVISIONS + 2), self.bounds.size.height / (DIVISIONS + 2));
	CGPoint m_point = CGPointMake((self.bounds.size.width - (m_block * DIVISIONS)) / 2, (self.bounds.size.height - (m_block * DIVISIONS)) / 2);
	
	// Invalidate text
    CGRect rectUpdate = CGRectMake(0, 0, (2 * m_point.x) + (DIVISIONS * m_block), m_point.y);
	[self setNeedsDisplayInRect:rectUpdate];
}

- (CGPoint)getTouchPosition:(NSSet *)touches {
    // Get touch position
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	
	// Calculate block size, starting point
	CGFloat m_block = MIN(self.bounds.size.width / (DIVISIONS + 2), self.bounds.size.height / (DIVISIONS + 2));
	CGPoint m_point = CGPointMake((self.bounds.size.width - (m_block * DIVISIONS)) / 2, (self.bounds.size.height - (m_block * DIVISIONS)) / 2);
	
	if (m_block > 0)
	{
		if(point.x < m_point.x)
			point.x = 0;
		else
			point.x = (short)(((point.x - m_point.x) / m_block) + 1);
		if(point.y < m_point.y)
			point.y = 0;
		else
			point.y = (short)(((point.y - m_point.y) / m_block) + 1);
		if(point.x > (DIVISIONS + 1))
			point.x = DIVISIONS + 1;
		if(point.y > (DIVISIONS + 1))
			point.y = DIVISIONS + 1;
    }
    
    return point;
}

@end
