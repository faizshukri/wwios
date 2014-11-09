//
//  GridCell.m
//  Wigly2
//
//  Created by Faiz Shukri on 11/6/14.
//  Copyright (c) 2014 Faiz Shukri. All rights reserved.
//

#import "GridCell.h"

@implementation GridCell

-(id) init {
    
    self = [super init];
    
    if(self){
        
        _default = [NSUserDefaults standardUserDefaults];
        
        // Initiate running status to true, and win status to be false
        self.isRunning = true;
        self.isWin = false;
        
        // Initiate score to 0
        self.score = 0;
        
        // Initiate cell object with uiimageview
        UIImage *emptyCell = [UIImage imageNamed:@"emptycell.png"];
        UIImage *wormFace = [UIImage imageNamed:@"wormface.png"];
        UIImage *wormBody = [UIImage imageNamed:@"snakecell.png"];
        UIImage *wormHole = [UIImage imageNamed:@"wormholecell.png"];
        UIImage *mushroom = [UIImage imageNamed:@"shroomcell.png"];
        
        self.emptyCell = [[UIImageView alloc] initWithImage:emptyCell];
        self.wormFace = [[UIImageView alloc] initWithImage:wormFace];
        self.wormBody = [[UIImageView alloc] initWithImage:wormBody];
        self.wormHole = [[UIImageView alloc] initWithImage:wormHole];
        self.mushroom = [[UIImageView alloc] initWithImage:mushroom];
        
        NSURL *soundUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"]];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        
        // Default direction is down
        self.currentDirection = 'd';
        
        // Populate initial grid.
        // Put emptycell, worm, wormhole and mushroom to the grid in that order
        [self populateInitialGrid];
    }
    
    return self;
}

-(void) populateInitialGrid {
    
    // The coordinate array will have value that represent the following
    // -1=>wormhole, 0=>emptycell, 1=>mushroom, 2=>worm
    
    // 1. Populate empty cell
    for (int i = 0; i < GRID_HEIGHT; i++) {
        for (int j = 0; j < GRID_WIDTH; j++) {
            _gridCoordinate[j][i] = EMPTY_CELL;
        }
    }
    
    // 2. Populate worm head
    // Default head is in the middle of the grid
    CGPoint head = CGPointMake(GRID_WIDTH / 2, GRID_HEIGHT / 2);
    
    // Insert the head portion to the worm position array
    self.wormPosition = [[NSMutableArray alloc] init];
    [self.wormPosition addObject:[NSValue valueWithCGPoint:head]];
    
    // Update the head in grid coordinate
    _gridCoordinate[ (int)head.x ][ (int)head.y ] = WORM_CELL;
    
    // 3. Populate wormhole
    for (int i = 0; i < [_default integerForKey:@"wormhole"]; i++) {
        CGPoint holePoint = [self getRandomEmptyCell];
        _gridCoordinate[(int)holePoint.x][(int)holePoint.y] = HOLE_CELL;
    }
    
    // 4. Populate mushroom
    for (int i = 0; i < PROB_OF_SHROOM * GRID_WIDTH * GRID_HEIGHT; i++) {
        CGPoint shroomPoint = [self getRandomEmptyCell];
        _gridCoordinate[(int)shroomPoint.x][(int)shroomPoint.y] = SHROOM_CELL;
    }
    

}

-(UIView*) gridImage {
    
    CGPoint head = [(NSValue*)[self.wormPosition objectAtIndex:0] CGPointValue];
    UIView *iv = [[UIView alloc] init];
    for (int i = 0; i < GRID_HEIGHT; i++) {
        for (int j = 0; j < GRID_WIDTH; j++) {
            UIImageView *cell;
            if( j == head.x && i == head.y ){
                cell = [[UIImageView alloc] initWithImage:self.wormFace.image];
            } else {
                switch (_gridCoordinate[j][i]) {
                    case HOLE_CELL:
                        cell = [[UIImageView alloc] initWithImage: self.wormHole.image];
                        break;
                    case EMPTY_CELL:
                        cell = [[UIImageView alloc] initWithImage: self.emptyCell.image];
                        break;
                    case SHROOM_CELL:
                        cell = [[UIImageView alloc] initWithImage: self.mushroom.image];
                        break;
                    case WORM_CELL:
                        cell = [[UIImageView alloc] initWithImage: self.wormBody.image];
                        break;
                }
            }
            cell.center = CGPointMake(20 * (j + 1) - 10, 20 * (i + 1) - 10);
            [iv addSubview:cell];
        }
    }
    return iv;
}

-(void) moveWorm {
    int x = 0, y = 0;
    switch (self.currentDirection) {
        case 'u':
            y -= 1;
            break;
        case 'd':
            y += 1;
            break;
        case 'l':
            x -= 1;
            break;
        case 'r':
            x += 1;
            break;
    }
    
    CGPoint tail = [(NSValue*)[self.wormPosition lastObject] CGPointValue];
    CGPoint newHead = [(NSValue*)[self.wormPosition objectAtIndex:0] CGPointValue];
    newHead.x += x;
    newHead.y += y;
    
    // User lost when
    // - head of worm breach the grid border
    // - head of worm breach it's body
    if(newHead.x >= GRID_WIDTH || newHead.x < 0 ||
       newHead.y >= GRID_HEIGHT || newHead.y < 0 ||
       _gridCoordinate[(int)newHead.x][(int)newHead.y] == HOLE_CELL ||
       _gridCoordinate[(int)newHead.x][(int)newHead.y] == WORM_CELL
       ){
        self.isRunning = false;
        return;
    }
    
    [self.wormPosition insertObject:[NSValue valueWithCGPoint:newHead] atIndex:0];
    
    //If head eat shroom, keep the tail, and put one more mushroom to the grid
    if(_gridCoordinate[(int)newHead.x][(int)newHead.y] == SHROOM_CELL){
        CGPoint newShroom = [self getRandomEmptyCell];
        _gridCoordinate[(int)newShroom.x][(int)newShroom.y] = SHROOM_CELL;
    //Else, remove the tail
    } else {
        [self.wormPosition removeLastObject];
    }
    
    if([_default boolForKey:@"sound"]) [_audioPlayer play];
    
    _gridCoordinate[(int)newHead.x][(int)newHead.y] = WORM_CELL;
    _gridCoordinate[(int)tail.x][(int)tail.y] = EMPTY_CELL;
    
    
    
    
    self.score += 10;
    
}

-(CGPoint) getRandomEmptyCell {
    int x, y;
    
    // Keep looping until location x and y in grid is empty
    while (true){
        x = arc4random() % GRID_WIDTH;
        y = arc4random() % GRID_HEIGHT;
        
        // If empty, exit the loop
        if(_gridCoordinate[x][y] == EMPTY_CELL) break;
    }
    
    return CGPointMake(x, y);
}

-(void) gameStop {
    [_audioPlayer stop];
}

@end
