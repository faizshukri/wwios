//
//  HighScoreViewController.h
//  Wigly2
//
//  Created by Faiz Shukri on 11/9/14.
//  Copyright (c) 2014 Faiz Shukri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighScoreViewController : UITableViewController {
    NSUserDefaults *_defaults;
}

@property NSMutableArray *scores;

-(NSMutableArray*) sortArray:(NSMutableArray*) array;

@end
