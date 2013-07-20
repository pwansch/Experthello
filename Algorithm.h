/*
 *  Algorithm.h
 *  Experthello
 *
 *  Created by Peter Wansch on 8/25/10.
 *  Copyright 2010, 2013 Peter Wansch. All rights reserved.
 *
 */

// Algorithm defines
#define DIVISIONS	8
#define EMPTY		0
#define PLAYER		1
#define COMPUTER	5
#define IND			32767

// Type definitions for board
typedef struct _BOARD
{
	short sField[DIVISIONS][DIVISIONS];
} BOARD;

typedef BOARD *PBOARD;

// Function prototypes
BOOL fIsMovePossible(BOARD Board, short sX, short sY, short sWho);
short sFlipped(PBOARD pBoard, short sX, short sY, short sWho);
void CopyBoard(BOARD BoardFrom, PBOARD pBoardTo);
BOOL fGameOver(BOARD Board);
BOOL fMustPass(BOARD Board, short sWho);
void Result(BOARD Board, short *psComputer, short *psPlayer);
short sSquare(BOARD Board, short sOwn, short sOpp, short sX, short sY);
short sOthello(BOARD Board, short sX, short sY, short sCurrentLevel, short sMaxLevel, short sWho, short *psX, short *psY, BOOL *pfValid, short sPrevBewertung);
short sBewertung(BOARD Board, short sXMoved, short sYMoved, short sWho);
void InvalidateGameField(short sX, short sY, CGPoint point, int block);
