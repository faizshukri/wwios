//
//  GameViewController.m
//  Wigly2
//
//  Created by Faiz Shukri on 11/6/14.
//  Copyright (c) 2014 Faiz Shukri. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

-(IBAction)btnPressed:(UIButton*)sender {
    const char *newDirection = [sender.restorationIdentifier UTF8String];
    char currentDirection = [self.gridCell currentDirection];
    
    // If game not start yet, start the timer, and set initial direction with the first direction button pressed
    if(!self.isStart){
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(update) userInfo:nil repeats:YES];
        [self.gridCell setCurrentDirection:newDirection[0]];
        
        self.isStart = true;
        
    // If the grame already start, we only allow direction that are next to current direction
    } else {
        if( (currentDirection == 'l' || currentDirection == 'r') &&
           (newDirection[0] == 'u' || newDirection[0] == 'd')
           ){
            [self.gridCell setCurrentDirection:newDirection[0]];
            
        } else if( (currentDirection == 'u' || currentDirection == 'd') &&
                  (newDirection[0] == 'l' || newDirection[0] == 'r')
                  ){
            [self.gridCell setCurrentDirection:newDirection[0]];
        }
    }
}

-(void) update {
    
    if(![self.gridCell isRunning]){
        [self.timer invalidate];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oh no, you died!" message:[NSString stringWithFormat:@"You scored %@", self.score.text] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"you lost");
        return;
    }
    
    if(self.isStart) [self.gridCell moveWorm];
    
    for(UIView *subView in [self.gridView subviews]){
        [subView removeFromSuperview];
    }
    
    [self.gridView addSubview:[self.gridCell gridImage]];
    self.score.text = [NSString stringWithFormat:@"%d", self.gridCell.score];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isStart = false;
    self.gridCell = [[GridCell alloc] init];
    [self update];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
