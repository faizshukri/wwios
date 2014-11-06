//
//  GridCell.h
//  Wigly2
//
//  Created by Faiz Shukri on 11/6/14.
//  Copyright (c) 2014 Faiz Shukri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define GRID_WIDTH          14
#define GRID_HEIGHT         20
#define NUM_OF_WORMHOLE     5
#define PROB_OF_SHROOM      0.2

enum CellType { EMPTY_CELL, HOLE_CELL, SHROOM_CELL, WORM_CELL };

@interface GridCell : NSObject {
    enum CellType _gridCoordinate[GRID_WIDTH][GRID_HEIGHT];
    int _wormHeadCoordinate[2];
}

@property UIImageView *emptyCell;
@property UIImageView *wormFace;
@property UIImageView *wormBody;
@property UIImageView *wormHole;
@property UIImageView *mushroom;

@property char currentDirection;
@property NSMutableArray *wormPosition;
@property bool isRunning;
@property bool isWin;

-(UIView*) gridImage;
-(void) moveWorm;
-(CGPoint) getRandomEmptyCell;

-(void) populateInitialGrid;

@end
