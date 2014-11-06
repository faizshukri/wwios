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

-(void) update {
    
    if(![self.gridCell isRunning]){
        [self.timer invalidate];
        NSLog(@"you lost");
        return;
    }
    [self.gridCell moveWorm];
    [self.gridCell getRandomEmptyCell];
    
    for(UIView *subView in [self.gridView subviews]){
        [subView removeFromSuperview];
    }
    [self.gridView addSubview:[self.gridCell gridImage]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.gridCell = [[GridCell alloc] init];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(update) userInfo:nil repeats:YES];
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
