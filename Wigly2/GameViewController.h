//
//  GameViewController.h
//  Wigly2
//
//  Created by Faiz Shukri on 11/6/14.
//  Copyright (c) 2014 Faiz Shukri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridCell.h"

@interface GameViewController : UIViewController {
    NSUserDefaults *_defaults;
}

@property (strong) IBOutlet UIView *gridView;
@property (strong) IBOutlet UILabel *score;
@property (strong) GridCell *gridCell;
@property int countdown;
@property (strong) IBOutlet UILabel *countdownLabel;
@property NSTimer *timer;
@property bool isStart;

-(IBAction)btnPressed:(UIButton*)sender;
-(IBAction)btnBack:(id)sender;
-(void) update;
@end
