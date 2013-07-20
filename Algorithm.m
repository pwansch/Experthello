/*
 *  Algorithm.c
 *  Experthello
 *
 *  Created by Peter Wansch on 8/25/10.
 *  Copyright 2010, 2013 Peter Wansch. All rights reserved.
 *
 */

#import "MainView.h"
#import "Algorithm.h"

BOOL fIsMovePossible(BOARD Board, short sX, short sY, short sWho)
{
	short i, sOpposite;
	
	if (Board.sField[sX][sY] != EMPTY)
		return NO;
	
	if(sWho == PLAYER)
		sOpposite = COMPUTER;
	else
		sOpposite = PLAYER;
	
	/* try north */
	if (sY < 6)
	{
		/* es wird zumindest ein Feld eingeschlossen */
		i = 1;
		while (((sY + i) < 7) && (Board.sField[sX][sY + i] == sOpposite))
			i++;
		if(Board.sField[sX][sY + i] == sWho && i > 1)
			return YES;
	}
	
	/* try south */
	if (sY > 1)
	{
		/* es wird zumindest ein Feld eingeschlossen */
		i = 1;
		while (((sY - i) > 0) && (Board.sField[sX][sY - i] == sOpposite))
			i++;
		if(Board.sField[sX][sY - i] == sWho && i > 1)
			return YES;
	}
	
	/* try west */
	if (sX > 1)
	{
		/* es wird zumindest ein Feld eingeschlossen */
		i = 1;
		while (((sX - i) > 0) && (Board.sField[sX - i][sY] == sOpposite))
			i++;
		if(Board.sField[sX - i][sY] == sWho && i > 1)
			return YES;
	}
	
	/* try east */
	if (sX < 6)
	{
		/* es wird zumindest ein Feld eingeschlossen */
		i = 1;
		while (((sX + i) < 7) && (Board.sField[sX + i][sY] == sOpposite))
			i++;
		if(Board.sField[sX + i][sY] == sWho && i > 1)
			return YES;
	}
	
	/* try north-east */
	if ((sX < 6) && (sY < 6))
	{
		/* es wird zumindest ein Feld eingeschlossen */
		i = 1;
		while (((sX + i) < 7) && ((sY + i) < 7) && (Board.sField[sX + i][sY + i] == sOpposite))
			i++;
		if(Board.sField[sX + i][sY + i] == sWho && i > 1)
			return YES;
	}
	
	/* try south-east */
	if ((sX < 6) && (sY > 1))
	{
		/* es wird zumindest ein Feld eingeschlossen */
		i = 1;
		while (((sX + i) < 7) && ((sY - i) > 0) && (Board.sField[sX + i][sY - i] == sOpposite))
			i++;
		if(Board.sField[sX + i][sY - i] == sWho && i > 1)
			return YES;
	}
	
	/* try south-west */
	if ((sX > 1) && (sY > 1))
	{
		/* es wird zumindest ein Feld eingeschlossen */
		i = 1;
		while (((sX - i) > 0) && ((sY - i) > 0) && (Board.sField[sX - i][sY - i] == sOpposite))
			i++;
		if(Board.sField[sX - i][sY - i] == sWho && i > 1)
			return YES;
	}
	
	/* try north-west */
	if ((sX > 1) && (sY < 6))
	{
		/* es wird zumindest ein Feld eingeschlossen */
		i = 1;
		while (((sY + i) < 7) && ((sX - i) > 0) && (Board.sField[sX - i][sY + i] == sOpposite))
			i++;
		if(Board.sField[sX - i][sY + i] == sWho && i > 1)
			return YES;
	}
	
	return NO;
}

short MakeMove(PBOARD pBoard, short sX, short sY, short sWho, BOOL fSimple, BOOL fInvalidate, MainView *mainView)
{
	short i, sOpposite, sNumberOfDirections, sDirectionsEval, sDiscsFlipped;
	BOARD boardHilf;
	
	if (!fSimple)
	{
		CopyBoard(*pBoard, &boardHilf);
		MakeMove(&boardHilf, sX, sY, sWho, YES, NO, mainView);
	}
	
	sDiscsFlipped = 0;
	sNumberOfDirections = 0;
	if(sWho == PLAYER)
		sOpposite = COMPUTER;
	else
		sOpposite = PLAYER;
	
	pBoard->sField[sX][sY] = sWho;
	if (fInvalidate)
		[mainView invalidateGameField:sX :sY];
	
	/* try north */
	if (sY < 6)
	{
		/* es wird zumindest ein Feld eingeschlossen */
		i = 1;
		while (((sY + i) < 7) && (pBoard->sField[sX][sY + i] == sOpposite))
		{
			i++;
		}
		if(pBoard->sField[sX][sY + i] == sWho && i > 1)
		{
			sNumberOfDirections++;
			/* umdrehen der Plaettchen */
			while(i > 1)
			{
				i--;
				pBoard->sField[sX][sY + i] = sWho;
				if (fInvalidate)
					[mainView invalidateGameField:sX :sY + i];
				
				if (!fSimple)
					sDiscsFlipped += sFlipped(&boardHilf, sX, sY + i, sWho);
			}
		}
	}
	
	/* try south */
	if (sY > 1)
	{
		/* es wird zumindest ein Feld eingeschlossen */
		i = 1;
		while (((sY - i) > 0) && (pBoard->sField[sX][sY - i] == sOpposite))
		{
			i++;
		}
		if(pBoard->sField[sX][sY - i] == sWho && i > 1)
		{
			sNumberOfDirections++;
			/* umdrehen der Plaettchen */
			while(i > 1)
			{
				i--;
				pBoard->sField[sX][sY - i] = sWho;
				if (fInvalidate)
					[mainView invalidateGameField:sX :sY - i];
				if (!fSimple)
					sDiscsFlipped += sFlipped(&boardHilf, sX, sY - i, sWho);
			}
		}
	}
	
	/* try west */
	if (sX > 1)
	{
		/* es wird zumindest ein Feld eingeschlossen */
		i = 1;
		while (((sX - i) > 0) && (pBoard->sField[sX - i][sY] == sOpposite))
		{
			i++;
		}
		if(pBoard->sField[sX - i][sY] == sWho && i > 1)
		{
			sNumberOfDirections++;
			/* umdrehen der Plaettchen */
			while(i > 1)
			{
				i--;
				pBoard->sField[sX - i][sY] = sWho;
				if (fInvalidate)
					[mainView invalidateGameField:sX - i :sY];
				if (!fSimple)
					sDiscsFlipped += sFlipped(&boardHilf, sX - i, sY, sWho);
			}
		}
	}
	
	/* try east */
	if (sX < 6)
	{
		/* es wird zumindest ein Feld eingeschlossen */
		i = 1;
		while (((sX + i) < 7) && (pBoard->sField[sX + i][sY] == sOpposite))
		{
			i++;
		}
		if(pBoard->sField[sX + i][sY] == sWho && i > 1)
		{
			sNumberOfDirections++;
			/* umdrehen der Plaettchen */
			while(i > 1)
			{
				i--;
				pBoard->sField[sX + i][sY] = sWho;
				if (fInvalidate)
					[mainView invalidateGameField:sX + i :sY];
				if (!fSimple)
					sDiscsFlipped += sFlipped(&boardHilf, sX + i, sY, sWho);
			}
		}
	}
	
	/* try north-east */
	if ((sX < 6) && (sY < 6))
	{
		/* es wird zumindest ein Feld eingeschlossen */
		i = 1;
		while (((sX + i) < 7) && ((sY + i) < 7) && (pBoard->sField[sX + i][sY + i] == sOpposite))
		{
			i++;
		}
		if(pBoard->sField[sX + i][sY + i] == sWho && i > 1)
		{
			sNumberOfDirections++;
			/* umdrehen der Plaettchen */
			while(i > 1)
			{
				i--;
				pBoard->sField[sX + i][sY + i] = sWho;
				if (fInvalidate)
					[mainView invalidateGameField:sX + i :sY + i];
				if (!fSimple)
					sDiscsFlipped += sFlipped(&boardHilf, sX + i, sY + i, sWho);
			}
		}
	}
	
	/* try south-east */
	if ((sX < 6) && (sY > 1))
	{
		/* es wird zumindest ein Feld eingeschlossen */
		i = 1;
		while (((sX + i) < 7) && ((sY - i) > 0) && (pBoard->sField[sX + i][sY - i] == sOpposite))
		{
			i++;
		}
		if(pBoard->sField[sX + i][sY - i] == sWho && i > 1)
		{
			sNumberOfDirections++;
			/* umdrehen der Plaettchen */
			while(i > 1)
			{
				i--;
				pBoard->sField[sX + i][sY - i] = sWho;
				if (fInvalidate)
					[mainView invalidateGameField:sX + i :sY - i];
				if (!fSimple)
					sDiscsFlipped += sFlipped(&boardHilf, sX + i, sY - i, sWho);
			}
		}
	}
	
	/* try south-west */
	if ((sX > 1) && (sY > 1))
	{
		/* es wird zumindest ein Feld eingeschlossen */
		i = 1;
		while (((sX - i) > 0) && ((sY - i) > 0) && (pBoard->sField[sX - i][sY - i] == sOpposite))
		{
			i++;
		}
		if(pBoard->sField[sX - i][sY - i] == sWho && i > 1)
		{
			sNumberOfDirections++;
			/* umdrehen der Plaettchen */
			while(i > 1)
			{
				i--;
				pBoard->sField[sX - i][sY - i] = sWho;
				if (fInvalidate)
					[mainView invalidateGameField:sX - i :sY - i];
				if (!fSimple)
					sDiscsFlipped += sFlipped(&boardHilf, sX - i, sY - i, sWho);
			}
		}
	}
	
	/* try north-west */
	if ((sX > 1) && (sY < 6))
	{
		/* es wird zumindest ein Feld eingeschlossen */
		i = 1;
		while (((sY + i) < 7) && ((sX - i) > 0) && (pBoard->sField[sX - i][sY + i] == sOpposite))
		{
			i++;
		}
		if(pBoard->sField[sX - i][sY + i] == sWho && i > 1)
		{
			sNumberOfDirections++;
			/* umdrehen der Plaettchen */
			while(i > 1)
			{
				i--;
				pBoard->sField[sX - i][sY + i] = sWho;
				if (fInvalidate)
					[mainView invalidateGameField:sX - i :sY + i];
				if (!fSimple)
					sDiscsFlipped += sFlipped(&boardHilf, sX - i, sY + i, sWho);
			}
		}
	}
	
	if (fSimple)
		return 0;
	
	switch (sNumberOfDirections)
	{
		case 1:
			sDirectionsEval = 0;
			break;
		case 2:
			sDirectionsEval = 5;
			break;
		case 3:
			sDirectionsEval = 15;
			break;
		default:
			sDirectionsEval = 20;
			break;
	}
	
	if (sWho == COMPUTER)
		return (sDiscsFlipped - sDirectionsEval);
	else
		return (sDirectionsEval - sDiscsFlipped);
}

short sFlipped(PBOARD pBoard, short sX, short sY, short sWho)
{
	short asFlipped[8][8] = {{0, 255, 0, 5, 5, 0, 255, 0},
							{255, 0, -10, 2, 2, -10, 0, 255},
							{0, -10, -5, 2, 2, -5, -10, 0},
							{5, 2, 2, 20, 20, 2, 2, 5},
							{5, 2, 2, 20, 20, 2, 2, 5},
							{0, -10, -5, 2, 2, -5, -10, 0},
							{255, 0, -10, 2, 2, -10, 0, 255},
							{0, 255, 0, 5, 5, 0, 255, 0}};	
	
	if ((sX == 0) && (sY == 2))
	{
		if ((pBoard->sField[0][0] == sWho) && (pBoard->sField[0][1] == sWho))
			return 150;
		else
			return 2;
	}
	
	if ((sX == 2) && (sY == 0))
	{
		if ((pBoard->sField[0][0] == sWho) && (pBoard->sField[1][0] == sWho))
			return 150;
		else
			return 2;
	}
	
	if ((sX == 5) && (sY == 0))
	{
		if ((pBoard->sField[7][0] == sWho) && (pBoard->sField[6][0] == sWho))
			return 150;
		else
			return 2;
	}
	
	if ((sX == 7) && (sY == 2))
	{
		if ((pBoard->sField[7][0] == sWho) && (pBoard->sField[7][1] == sWho))
			return 150;
		else
			return 2;
	}
	
	if ((sX == 0) && (sY == 5))
	{
		if ((pBoard->sField[0][7] == sWho) && (pBoard->sField[0][6] == sWho))
			return 150;
		else
			return 2;
	}
	
	if ((sX == 2) && (sY == 7))
	{
		if ((pBoard->sField[0][7] == sWho) && (pBoard->sField[1][7] == sWho))
			return 150;
		else
			return 2;
	}
	
	if ((sX == 5) && (sY == 7))
	{
		if ((pBoard->sField[7][7] == sWho) && (pBoard->sField[6][7] == sWho))
			return 150;
		else
			return 2;
	}
	
	if ((sX == 7) && (sY == 5))
	{
		if ((pBoard->sField[7][7] == sWho) && (pBoard->sField[7][6] == sWho))
			return 150;
		else
			return 2;
	}
	
	return (asFlipped[sX][sY]);
}

void CopyBoard(BOARD BoardFrom, PBOARD pBoardTo)
{
	short sX, sY;
	
	for(sX = 0; sX < DIVISIONS; sX++)
		for(sY = 0; sY < DIVISIONS; sY++)
			pBoardTo->sField[sX][sY] = BoardFrom.sField[sX][sY];
}

/* returns YES if the game is over */
BOOL fGameOver(BOARD Board)
{
	if(!fMustPass(Board, COMPUTER) || !fMustPass(Board, PLAYER))
		return NO;
	return YES;
}

/* returns YES if no move is possible */
BOOL fMustPass(BOARD Board, short sWho)
{
	short sX, sY;
	
	for(sX = 0; sX < 8; sX++)
		for(sY = 0; sY < 8; sY++)
		{
			if (fIsMovePossible(Board, sX, sY, sWho))
				return NO;
		}
	
	return YES;
}

void Result(BOARD Board, short *psComputer, short *psPlayer)
{
	short sX, sY, sumPlayer, sumComputer;
	
	sumPlayer = 0;
	sumComputer = 0;
	
	for(sX = 0; sX < 8; sX++)
		for(sY = 0; sY < 8; sY++)
		{
			switch (Board.sField[sX][sY])
			{
				case PLAYER:
					sumPlayer++;
					break;
				case COMPUTER:
					sumComputer++;
					break;
			}
		}
	*psComputer = sumComputer;
	*psPlayer = sumPlayer;
}

short sSquare(BOARD Board, short sOwn, short sOpp, short sX, short sY)
{
	/* Corners */
	if (sX == 0 && sY == 7)
	{
		if (Board.sField[1][7] == EMPTY && Board.sField[2][7] == sOwn && Board.sField[2][6] == sOwn)
		{
			if (Board.sField[6][7] == sOwn)
				return 100;
			else
				return 150;
		}
		if (Board.sField[0][6] == EMPTY && Board.sField[0][5] == sOwn && Board.sField[1][5] == sOwn)
		{
			if (Board.sField[0][1] == sOwn)
				return 100;
			else
				return 150;
		}
		
		if (Board.sField[1][7] != EMPTY || Board.sField[0][6] != EMPTY)
			return 400;
		return 255;
	}
	if (sX == 0 && sY == 0)
	{
		if (Board.sField[1][0] == EMPTY && Board.sField[2][0] == sOwn && Board.sField[2][1] == sOwn)
		{
			if (Board.sField[6][0] == sOwn)
				return 100;
			else
				return 150;
		}
		if (Board.sField[0][1] == EMPTY && Board.sField[0][2] == sOwn && Board.sField[1][2] == sOwn)
		{
			if (Board.sField[0][6] == sOwn)
				return 100;
			else
				return 150;
		}
		
		if (Board.sField[1][0] != EMPTY || Board.sField[0][1] != EMPTY)
			return 400;
		return 255;
	}
	if (sX == 7 && sY == 0)
	{
		if (Board.sField[6][0] == EMPTY && Board.sField[5][0] == sOwn && Board.sField[5][1] == sOwn)
		{
			if (Board.sField[1][0] == sOwn)
				return 100;
			else
				return 150;
		}
		if (Board.sField[7][1] == EMPTY && Board.sField[7][2] == sOwn && Board.sField[6][2] == sOwn)
		{
			if (Board.sField[7][6] == sOwn)
				return 100;
			else
				return 150;
		}
		
		if (Board.sField[6][0] != EMPTY || Board.sField[7][1] != EMPTY)
			return 400;
		return 255;
	}
	if (sX == 7 && sY == 7)
	{
		if (Board.sField[6][7] == EMPTY && Board.sField[5][7] == sOwn && Board.sField[5][6] == sOwn)
		{
			if (Board.sField[1][7] == sOwn)
				return 100;
			else
				return 150;
		}
		if (Board.sField[7][6] == EMPTY && Board.sField[7][5] == sOwn && Board.sField[6][5] == sOwn)
		{
			if (Board.sField[7][1] == sOwn)
				return 100;
			else
				return 150;
		}
		
		if (Board.sField[6][7] != EMPTY || Board.sField[7][6] != EMPTY)
			return 400;
		return 255;
	}
	
	/* C squares */
	if (sX == 1 && sY == 7)
	{
		if (Board.sField[0][7] == sOwn)
			return 175;
		if (Board.sField[0][7] == sOpp)
			return 2;
		if (Board.sField[2][7] == EMPTY)
			return -150;
		if (Board.sField[2][7] == sOpp)
			return -100;
		if (Board.sField[3][7] == EMPTY)
			return -150;
		if (Board.sField[3][7] == sOpp)
			return -100;
		
		if (Board.sField[4][7] == EMPTY)
		{
			if (Board.sField[3][6] == sOpp)
				return 10;
			else
				return -150;
		}
		
		if (Board.sField[4][7] == sOpp)
			return -100;
		
		if (Board.sField[5][7] == EMPTY)
			return 10;
		if (Board.sField[5][7] == sOpp)
			return -100;
		
		if (Board.sField[6][7] == EMPTY)
		{
			if (Board.sField[5][6] == sOwn)
				return -225;
			else
				return 10;
		}
		if (Board.sField[6][7] == sOpp)
			return -100;
		if (Board.sField[7][7] == sOpp)
			return -100;
		return 175;
	}
	if (sX == 6 && sY == 7)
	{
		if (Board.sField[7][7] == sOwn)
			return 175;
		if (Board.sField[7][7] == sOpp)
			return 2;
		if (Board.sField[5][7] == EMPTY)
			return -150;
		if (Board.sField[5][7] == sOpp)
			return -100;
		if (Board.sField[4][7] == EMPTY)
			return -150;
		if (Board.sField[4][7] == sOpp)
			return -100;
		
		if (Board.sField[3][7] == EMPTY)
		{
			if (Board.sField[4][6] == sOpp)
				return 10;
			else
				return -150;
		}
		
		if (Board.sField[3][7] == sOpp)
			return -100;
		
		if (Board.sField[2][7] == EMPTY)
			return 10;
		if (Board.sField[2][7] == sOpp)
			return -100;
		
		if (Board.sField[1][7] == EMPTY)
		{
			if (Board.sField[2][6] == sOwn)
				return -225;
			else
				return 10;
		}
		if (Board.sField[1][7] == sOpp)
			return -100;
		if (Board.sField[0][7] == sOpp)
			return -100;
		return 175;
	}
	if (sX == 1 && sY == 0)
	{
		if (Board.sField[0][0] == sOwn)
			return 175;
		if (Board.sField[0][0] == sOpp)
			return 2;
		if (Board.sField[2][0] == EMPTY)
			return -150;
		if (Board.sField[2][0] == sOpp)
			return -100;
		if (Board.sField[3][0] == EMPTY)
			return -150;
		if (Board.sField[3][0] == sOpp)
			return -100;
		
		if (Board.sField[4][0] == EMPTY)
		{
			if (Board.sField[3][1] == sOpp)
				return 10;
			else
				return -150;
		}
		
		if (Board.sField[4][0] == sOpp)
			return -100;
		
		if (Board.sField[5][0] == EMPTY)
			return 10;
		if (Board.sField[5][0] == sOpp)
			return -100;
		
		if (Board.sField[6][0] == EMPTY)
		{
			if (Board.sField[5][1] == sOwn)
				return -225;
			else
				return 10;
		}
		if (Board.sField[6][0] == sOpp)
			return -100;
		if (Board.sField[7][0] == sOpp)
			return -100;
		return 175;
	}
	if (sX == 6 && sY == 0)
	{
		if (Board.sField[7][0] == sOwn)
			return 175;
		if (Board.sField[7][0] == sOpp)
			return 2;
		if (Board.sField[5][0] == EMPTY)
			return -150;
		if (Board.sField[5][0] == sOpp)
			return -100;
		if (Board.sField[4][0] == EMPTY)
			return -150;
		if (Board.sField[4][0] == sOpp)
			return -100;
		
		if (Board.sField[3][0] == EMPTY)
		{
			if (Board.sField[4][1] == sOpp)
				return 10;
			else
				return -150;
		}
		
		if (Board.sField[3][0] == sOpp)
			return -100;
		
		if (Board.sField[2][0] == EMPTY)
			return 10;
		if (Board.sField[2][0] == sOpp)
			return -100;
		
		if (Board.sField[1][0] == EMPTY)
		{
			if (Board.sField[2][1] == sOwn)
				return -225;
			else
				return 10;
		}
		if (Board.sField[1][0] == sOpp)
			return -100;
		if (Board.sField[0][0] == sOpp)
			return -100;
		return 175;
	}
	if (sX == 7 && sY == 6)
	{
		if (Board.sField[7][7] == sOwn)
			return 175;
		if (Board.sField[7][7] == sOpp)
			return 2;
		if (Board.sField[7][5] == EMPTY)
			return -150;
		if (Board.sField[7][5] == sOpp)
			return -100;
		if (Board.sField[7][4] == EMPTY)
			return -150;
		if (Board.sField[7][4] == sOpp)
			return -100;
		
		if (Board.sField[7][3] == EMPTY)
		{
			if (Board.sField[6][4] == sOpp)
				return 10;
			else
				return -150;
		}
		
		if (Board.sField[7][3] == sOpp)
			return -100;
		
		if (Board.sField[7][2] == EMPTY)
			return 10;
		if (Board.sField[7][2] == sOpp)
			return -100;
		
		if (Board.sField[7][1] == EMPTY)
		{
			if (Board.sField[6][2] == sOwn)
				return -225;
			else
				return 10;
		}
		if (Board.sField[7][1] == sOpp)
			return -100;
		if (Board.sField[7][0] == sOpp)
			return -100;
		return 175;
	}
	if (sX == 7 && sY == 1)
	{
		if (Board.sField[7][0] == sOwn)
			return 175;
		if (Board.sField[7][0] == sOpp)
			return 2;
		if (Board.sField[7][2] == EMPTY)
			return -150;
		if (Board.sField[7][2] == sOpp)
			return -100;
		if (Board.sField[7][3] == EMPTY)
			return -150;
		if (Board.sField[7][3] == sOpp)
			return -100;
		
		if (Board.sField[7][4] == EMPTY)
		{
			if (Board.sField[6][3] == sOpp)
				return 10;
			else
				return -150;
		}
		
		if (Board.sField[7][4] == sOpp)
			return -100;
		
		if (Board.sField[7][5] == EMPTY)
			return 10;
		if (Board.sField[7][5] == sOpp)
			return -100;
		
		if (Board.sField[7][6] == EMPTY)
		{
			if (Board.sField[6][5] == sOwn)
				return -225;
			else
				return 10;
		}
		if (Board.sField[7][6] == sOpp)
			return -100;
		if (Board.sField[7][7] == sOpp)
			return -100;
		return 175;
	}
	if (sX == 0 && sY == 6)
	{
		if (Board.sField[0][7] == sOwn)
			return 175;
		if (Board.sField[0][7] == sOpp)
			return 2;
		if (Board.sField[0][5] == EMPTY)
			return -150;
		if (Board.sField[0][5] == sOpp)
			return -100;
		if (Board.sField[0][4] == EMPTY)
			return -150;
		if (Board.sField[0][4] == sOpp)
			return -100;
		
		if (Board.sField[0][3] == EMPTY)
		{
			if (Board.sField[1][4] == sOpp)
				return 10;
			else
				return -150;
		}
		
		if (Board.sField[0][3] == sOpp)
			return -100;
		
		if (Board.sField[0][2] == EMPTY)
			return 10;
		if (Board.sField[0][2] == sOpp)
			return -100;
		
		if (Board.sField[0][1] == EMPTY)
		{
			if (Board.sField[1][2] == sOwn)
				return -225;
			else
				return 10;
		}
		if (Board.sField[0][1] == sOpp)
			return -100;
		if (Board.sField[0][0] == sOpp)
			return -100;
		return 175;
	}
	if (sX == 0 && sY == 1)
	{
		if (Board.sField[0][0] == sOwn)
			return 175;
		if (Board.sField[0][0] == sOpp)
			return 2;
		if (Board.sField[0][2] == EMPTY)
			return -150;
		if (Board.sField[0][2] == sOpp)
			return -100;
		if (Board.sField[0][3] == EMPTY)
			return -150;
		if (Board.sField[0][3] == sOpp)
			return -100;
		
		if (Board.sField[0][4] == EMPTY)
		{
			if (Board.sField[1][3] == sOpp)
				return 10;
			else
				return -150;
		}
		
		if (Board.sField[0][4] == sOpp)
			return -100;
		
		if (Board.sField[0][5] == EMPTY)
			return 10;
		if (Board.sField[0][5] == sOpp)
			return -100;
		
		if (Board.sField[0][6] == EMPTY)
		{
			if (Board.sField[1][5] == sOwn)
				return -225;
			else
				return 10;
		}
		if (Board.sField[0][6] == sOpp)
			return -100;
		if (Board.sField[0][7] == sOpp)
			return -100;
		return 175;
	}
	
	/* A squares */
	if (sX == 2 && sY == 7)
	{
		if (Board.sField[3][7] != EMPTY)
		{
			if (Board.sField[2][6] == EMPTY)
				return 35;
		}
		else
		{
			if (Board.sField[4][7] == sOpp)
				return 25;
			else
				if (Board.sField[4][7] == EMPTY && Board.sField[5][7] == sOwn)
					return 35;
		}
		return 12;
	}
	if (sX == 5 && sY == 7)
	{
		if (Board.sField[4][7] != EMPTY)
		{
			if (Board.sField[5][6] == EMPTY)
				return 35;
		}
		else
		{
			if (Board.sField[3][7] == sOpp)
				return 25;
			else
				if (Board.sField[3][7] == EMPTY && Board.sField[2][7] == sOwn)
					return 35;
		}
		return 12;
	}
	if (sX == 7 && sY == 5)
	{
		if (Board.sField[7][4] != EMPTY)
		{
			if (Board.sField[6][3] == EMPTY)
				return 35;
		}
		else
		{
			if (Board.sField[7][3] == sOpp)
				return 25;
			else
				if (Board.sField[7][3] == EMPTY && Board.sField[7][2] == sOwn)
					return 35;
		}
		return 12;
	}
	if (sX == 7 && sY == 2)
	{
		if (Board.sField[7][3] != EMPTY)
		{
			if (Board.sField[6][2] == EMPTY)
				return 35;
		}
		else
		{
			if (Board.sField[7][4] == sOpp)
				return 25;
			else
				if (Board.sField[7][4] == EMPTY && Board.sField[7][5] == sOwn)
					return 35;
		}
		return 12;
	}
	if (sX == 5 && sY == 0)
	{
		if (Board.sField[4][0] != EMPTY)
		{
			if (Board.sField[5][1] == EMPTY)
				return 35;
		}
		else
		{
			if (Board.sField[3][0] == sOpp)
				return 25;
			else
				if (Board.sField[3][0] == EMPTY && Board.sField[2][0] == sOwn)
					return 35;
		}
		return 12;
	}
	if (sX == 2 && sY == 0)
	{
		if (Board.sField[3][0] != EMPTY)
		{
			if (Board.sField[2][1] == EMPTY)
				return 35;
		}
		else
		{
			if (Board.sField[4][0] == sOpp)
				return 25;
			else
				if (Board.sField[4][0] == EMPTY && Board.sField[5][0] == sOwn)
					return 35;
		}
		return 12;
	}
	if (sX == 0 && sY == 2)
	{
		if (Board.sField[0][3] != EMPTY)
		{
			if (Board.sField[1][2] == EMPTY)
				return 35;
		}
		else
		{
			if (Board.sField[0][4] == sOpp)
				return 25;
			else
				if (Board.sField[0][4] == EMPTY && Board.sField[0][5] == sOwn)
					return 35;
		}
		return 12;
	}
	if (sX == 0 && sY == 5)
	{
		if (Board.sField[0][4] != EMPTY)
		{
			if (Board.sField[1][5] == EMPTY)
				return 35;
		}
		else
		{
			if (Board.sField[0][3] == sOpp)
				return 25;
			else
				if (Board.sField[0][3] == EMPTY && Board.sField[0][2] == sOwn)
					return 35;
		}
		return 12;
	}
	
	/* B squares */
	if (sX == 3 && sY == 7)
	{
		if (Board.sField[4][7] == EMPTY)
		{
			if (Board.sField[5][7] == sOpp)
				return 30;
		}
		else
		{
			if (Board.sField[4][7] == Board.sField[2][7])
				return 30;
		}
		return 12;
	}
	if (sX == 4 && sY == 7)
	{
		if (Board.sField[3][7] == EMPTY)
		{
			if (Board.sField[2][7] == sOpp)
				return 30;
		}
		else
		{
			if (Board.sField[3][7] == Board.sField[5][7])
				return 30;
		}
		return 12;
	}
	if (sX == 7 && sY == 4)
	{
		if (Board.sField[7][3] == EMPTY)
		{
			if (Board.sField[7][2] == sOpp)
				return 30;
		}
		else
		{
			if (Board.sField[7][3] == Board.sField[7][5])
				return 30;
		}
		return 12;
	}
	if (sX == 7 && sY == 3)
	{
		if (Board.sField[7][4] == EMPTY)
		{
			if (Board.sField[7][5] == sOpp)
				return 30;
		}
		else
		{
			if (Board.sField[7][4] == Board.sField[7][2])
				return 30;
		}
		return 12;
	}
	if (sX == 4 && sY == 0)
	{
		if (Board.sField[3][0] == EMPTY)
		{
			if (Board.sField[2][0] == sOpp)
				return 30;
		}
		else
		{
			if (Board.sField[3][0] == Board.sField[5][0])
				return 30;
		}
		return 12;
	}
	if (sX == 3 && sY == 0)
	{
		if (Board.sField[4][0] == EMPTY)
		{
			if (Board.sField[5][0] == sOpp)
				return 30;
		}
		else
		{
			if (Board.sField[4][0] == Board.sField[2][0])
				return 30;
		}
		return 12;
	}
	if (sX == 0 && sY == 3)
	{
		if (Board.sField[0][4] == EMPTY)
		{
			if (Board.sField[0][5] == sOpp)
				return 30;
		}
		else
		{
			if (Board.sField[0][4] == Board.sField[0][2])
				return 30;
		}
		return 12;
	}
	if (sX == 0 && sY == 4)
	{
		if (Board.sField[0][3] == EMPTY)
		{
			if (Board.sField[0][2] == sOpp)
				return 30;
		}
		else
		{
			if (Board.sField[0][5] == Board.sField[0][3])
				return 30;
		}
		return 12;
	}
	
	/* X squares */
	if (sX == 1 && sY == 6)
	{
		if (Board.sField[0][7] == sOwn)
			return 100;
		if (Board.sField[0][7] == sOpp)
			return 2;
		if (Board.sField[6][7] == sOpp || Board.sField[0][1] == sOpp)
			return -100;
		return -200;
	}
	if (sX == 6 && sY == 6)
	{
		if (Board.sField[7][7] == sOwn)
			return 100;
		if (Board.sField[7][7] == sOpp)
			return 2;
		if (Board.sField[1][7] == sOpp || Board.sField[7][1] == sOpp)
			return -100;
		return -200;
	}
	if (sX == 6 && sY == 1)
	{
		if (Board.sField[7][0] == sOwn)
			return 100;
		if (Board.sField[7][0] == sOpp)
			return 2;
		if (Board.sField[7][6] == sOpp || Board.sField[1][0] == sOpp)
			return -100;
		return -200;
	}
	if (sX == 1 && sY == 1)
	{
		if (Board.sField[0][0] == sOwn)
			return 100;
		if (Board.sField[0][0] == sOpp)
			return 2;
		if (Board.sField[6][0] == sOpp || Board.sField[0][6] == sOpp)
			return -100;
		return -200;
	}
	
	/* F squares */
	if (sX == 2 && sY == 6)
	{
		if (Board.sField[2][7] != EMPTY && Board.sField[1][7] != EMPTY)
			return 25;
		if (Board.sField[3][7] == sOpp)
			return 5;
		return -5;
	}
	if (sX == 1 && sY == 5)
	{
		if (Board.sField[0][6] != EMPTY && Board.sField[0][5] != EMPTY)
			return 25;
		if (Board.sField[0][4] == sOpp)
			return 5;
		return -5;
	}
	if (sX == 1 && sY == 2)
	{
		if (Board.sField[0][1] != EMPTY && Board.sField[0][2] != EMPTY)
			return 25;
		if (Board.sField[0][3] == sOpp)
			return 5;
		return -5;
	}
	if (sX == 2 && sY == 1)
	{
		if (Board.sField[1][0] != EMPTY && Board.sField[2][0] != EMPTY)
			return 25;
		if (Board.sField[3][0] == sOpp)
			return 5;
		return -5;
	}
	if (sX == 5 && sY == 1)
	{
		if (Board.sField[6][0] != EMPTY && Board.sField[5][0] != EMPTY)
			return 25;
		if (Board.sField[4][0] == sOpp)
			return 5;
		return -5;
	}
	if (sX == 6 && sY == 2)
	{
		if (Board.sField[7][1] != EMPTY && Board.sField[7][2] != EMPTY)
			return 25;
		if (Board.sField[7][3] == sOpp)
			return 5;
		return -5;
	}
	if (sX == 6 && sY == 5)
	{
		if (Board.sField[7][6] != EMPTY && Board.sField[7][5] != EMPTY)
			return 25;
		if (Board.sField[7][4] == sOpp)
			return 5;
		return -5;
	}
	if (sX == 5 && sY == 6)
	{
		if (Board.sField[6][7] != EMPTY && Board.sField[5][7] != EMPTY)
			return 25;
		if (Board.sField[4][7] == sOpp)
			return 5;
		return -5;
	}
	
	/* G squares */
	if (sX == 3 && sY == 6)
	{
		if (Board.sField[2][6] != EMPTY || Board.sField[4][6] != EMPTY)
			return 30;
		return 18;
	}
	if (sX == 4 && sY == 6)
	{
		if (Board.sField[3][6] != EMPTY || Board.sField[5][6] != EMPTY)
			return 30;
		return 18;
	}
	if (sX == 6 && sY == 4)
	{
		if (Board.sField[6][3] != EMPTY || Board.sField[6][5] != EMPTY)
			return 30;
		return 18;
	}
	if (sX == 6 && sY == 3)
	{
		if (Board.sField[6][2] != EMPTY || Board.sField[6][4] != EMPTY)
			return 30;
		return 18;
	}
	if (sX == 4 && sY == 1)
	{
		if (Board.sField[5][1] != EMPTY || Board.sField[3][1] != EMPTY)
			return 30;
		return 18;
	}
	if (sX == 3 && sY == 1)
	{
		if (Board.sField[2][1] != EMPTY || Board.sField[4][1] != EMPTY)
			return 30;
		return 18;
	}
	if (sX == 1 && sY == 3)
	{
		if (Board.sField[1][2] != EMPTY || Board.sField[1][4] != EMPTY)
			return 30;
		return 18;
	}
	if (sX == 1 && sY == 4)
	{
		if (Board.sField[1][3] != EMPTY || Board.sField[1][5] != EMPTY)
			return 30;
		return 18;
	}
	
	/* D squares */
	if (sX == 2 && sY == 5)
	{
		if (Board.sField[3][5] != EMPTY && Board.sField[2][4] != EMPTY)
			return 50;
		return 20;
	}
	if (sX == 5 && sY == 5)
	{
		if (Board.sField[5][4] != EMPTY && Board.sField[4][5] != EMPTY)
			return 50;
		return 20;
	}
	if (sX == 5 && sY == 2)
	{
		if (Board.sField[5][3] != EMPTY && Board.sField[4][2] != EMPTY)
			return 50;
		return 20;
	}
	if (sX == 2 && sY == 2)
	{
		if (Board.sField[3][2] != EMPTY && Board.sField[2][3] != EMPTY)
			return 50;
		return 20;
	}
	
	/* E squares */
	if (sX == 3 && sY == 5)
	{
		if (Board.sField[2][5] != EMPTY || Board.sField[3][6] != EMPTY)
			return 40;
		return 20;
	}
	if (sX == 4 && sY == 5)
	{
		if (Board.sField[4][6] != EMPTY || Board.sField[5][5] != EMPTY)
			return 40;
		return 20;
	}
	if (sX == 5 && sY == 4)
	{
		if (Board.sField[6][4] != EMPTY || Board.sField[5][5] != EMPTY)
			return 40;
		return 20;
	}
	if (sX == 5 && sY == 3)
	{
		if (Board.sField[5][2] != EMPTY || Board.sField[6][3] != EMPTY)
			return 40;
		return 20;
	}
	if (sX == 4 && sY == 2)
	{
		if (Board.sField[5][2] != EMPTY || Board.sField[4][1] != EMPTY)
			return 40;
		return 20;
	}
	if (sX == 3 && sY == 2)
	{
		if (Board.sField[3][1] != EMPTY || Board.sField[2][2] != EMPTY)
			return 40;
		return 20;
	}
	if (sX == 2 && sY == 3)
	{
		if (Board.sField[2][2] != EMPTY || Board.sField[1][3] != EMPTY)
			return 40;
		return 20;
	}
	if (sX == 2 && sY == 4)
	{
		if (Board.sField[1][4] != EMPTY || Board.sField[2][5] != EMPTY)
			return 40;
		return 20;
	}
	
	return 0;
}

/* berechnet: value of the square occupied and mobility */
short sBewertung(BOARD Board, short sXMoved, short sYMoved, short sWho)
{
	short sMobility, sX, sY, sOptions;
	
	sOptions = 0;
	sMobility = 0;
	
	/* mobility bestimmen */
	for(sX = 0; sX < 8; sX++)
		for(sY = 0; sY < 8; sY++)
		{
			if (fIsMovePossible(Board, sX, sY, sWho))
			{
				sOptions++;
				/* X squares */
				if ((sX == 1) && (sY == 1))
				{
					if(Board.sField[0][0] != EMPTY)
						sMobility += 40;
					continue;
				}
				
				if ((sX == 1) && (sY == 6))
				{
					if(Board.sField[0][7] != EMPTY)
						sMobility += 40;
					continue;
				}
				
				if ((sX == 6) && (sY == 1))
				{
					if(Board.sField[7][0] != EMPTY)
						sMobility += 40;
					continue;
				}
				
				if ((sX == 6) && (sY == 6))
				{
					if(Board.sField[7][7] != EMPTY)
						sMobility += 40;
					continue;
				}
				
				/* C squares */
				if ((sX == 1) && (sY == 0) && (Board.sField[0][0] == EMPTY))
				{
					sMobility += 20;
					continue;
				}
				
				if ((sX == 0) && (sY == 1) && (Board.sField[0][0] == EMPTY))
				{
					sMobility += 20;
					continue;
				}
				
				if ((sX == 0) && (sY == 6) && (Board.sField[0][7] == EMPTY))
				{
					sMobility += 20;
					continue;
				}
				
				if ((sX == 1) && (sY == 7) && (Board.sField[0][7] == EMPTY))
				{
					sMobility += 20;
					continue;
				}
				
				if ((sX == 6) && (sY == 7) && (Board.sField[7][7] == EMPTY))
				{
					sMobility += 20;
					continue;
				}
				
				if ((sX == 7) && (sY == 6) && (Board.sField[7][7] == EMPTY))
				{
					sMobility += 20;
					continue;
				}
				
				if ((sX == 6) && (sY == 0) && (Board.sField[7][0] == EMPTY))
				{
					sMobility += 20;
					continue;
				}
				
				if ((sX == 7) && (sY == 1) && (Board.sField[7][0] == EMPTY))
				{
					sMobility += 20;
					continue;
				}
				
				sMobility += 40;
			}
		}
	
	/* is it a forced move? */
	if (sOptions == 1)
		sMobility = 0;
	
	if (sWho == COMPUTER)
		return (sMobility + sSquare(Board, COMPUTER, PLAYER, sXMoved, sYMoved));
	else
		return (-(sMobility + sSquare(Board, PLAYER, COMPUTER, sXMoved, sYMoved)));
}

/* if no move is possible just return NO */
short sOthello(BOARD Board, short sX, short sY, short sCurrentLevel, short sMaxLevel, short sWho, short *psX, short *psY, BOOL *pfValid, short sPrevBewertung)
{
	BOOL fGotAMove, fTemp;
	short max, min, sXInd, sYInd, sWhoNext, sMaxIndizesInd, sTemp1, sTemp2, sBew, sDirectionsComp;
	short sMaxIndizes[64][2];
	
	max = -IND;
	min = IND;
	
	if (sCurrentLevel == 0)
	{
		/* find the best move or return NO */
		sMaxIndizesInd = 0;
		fGotAMove = NO;
		for (sXInd = 0; sXInd < 8; sXInd++)
			for (sYInd = 0; sYInd < 8; sYInd++)
			{
				
				if (fIsMovePossible(Board, sXInd, sYInd, COMPUTER))
				{
					fGotAMove = YES;
					sBew = sOthello(Board, sXInd, sYInd, sCurrentLevel + 1, sMaxLevel, sWho, &sTemp1, &sTemp2, &fTemp, 0);
					
					if(sBew > max)
					{
						max = sBew;
						sMaxIndizesInd = 0;
						sMaxIndizes[0][0] = sXInd;
						sMaxIndizes[0][1] = sYInd;
					}
					else
					{
						if(sBew == max)
						{
							sMaxIndizesInd ++;
							sMaxIndizes[sMaxIndizesInd][0] = sXInd;
							sMaxIndizes[sMaxIndizesInd][1] = sYInd;
						}
					}
				}
			}
		if(fGotAMove)
		{ 
			sBew = abs(rand() % (sMaxIndizesInd + 1));
			*psX = sMaxIndizes[sBew][0];
			*psY = sMaxIndizes[sBew][1];
			*pfValid = YES;
		}
		else
			*pfValid = NO;
		return 0;
	}
	else
	{
		/* Zug machen */
		sDirectionsComp = MakeMove(&Board, sX, sY, sWho, NO, NO, nil);
		
		/* max level ?, dann Blatt berechnen, Zug ist schon gemacht */
		if (sCurrentLevel == sMaxLevel)
			return (sBewertung(Board, sX, sY, sWho) + sPrevBewertung + sDirectionsComp);
		
		/* sonst weitergehen und Minimum der gueltigen Nachfolger bestimmen */
		if (sWho == COMPUTER)
			sWhoNext = PLAYER;
		else
			sWhoNext = COMPUTER;
		for (sXInd = 0; sXInd < 8; sXInd++)
			for (sYInd = 0; sYInd < 8; sYInd++)
			{
				if (fIsMovePossible(Board, sXInd, sYInd, sWhoNext))
				{
					sBew = sOthello(Board, sXInd, sYInd, sCurrentLevel + 1, sMaxLevel, sWhoNext, &sTemp1, &sTemp2, &fTemp, sPrevBewertung + sBewertung(Board, sX, sY, sWho) + sDirectionsComp);
					if (sBew <= min)
						min = sBew;
				}
			}
		return min;
	}
}
