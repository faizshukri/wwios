//
//  GameViewController.h
//  Wigly2
//
//  Created by Faiz Shukri on 11/6/14.
//  Copyright (c) 2014 Faiz Shukri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridCell.h"

@interface GameViewController : UIViewController

@property (strong) IBOutlet UIView *gridView;
@property (strong) GridCell *gridCell;
@property NSTimer *timer;

-(IBAction)btnPressed:(UIButton*)sender;
-(void) update;
@end
