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

-(IBAction)btnBack:(id)sender {
    [self.timer invalidate];
    [self.gridCell gameStop];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnPressed:(UIButton*)sender {
    // Get new direction from restoration identifier as character
    const char *newDirection = [sender.restorationIdentifier UTF8String];
    char currentDirection = [self.gridCell currentDirection];
    
    // Only accept adjacent direction, not the opposite one
    
    // If current direction is L/R, we only accept U/D
    if( (currentDirection == 'l' || currentDirection == 'r') &&
       (newDirection[0] == 'u' || newDirection[0] == 'd')
       ){
        [self.gridCell setCurrentDirection:newDirection[0]];
        
    // vice versa, if current direction is U/D, we only accept L/R
    } else if( (currentDirection == 'u' || currentDirection == 'd') &&
              (newDirection[0] == 'l' || newDirection[0] == 'r')
              ){
        [self.gridCell setCurrentDirection:newDirection[0]];
    }
}

-(IBAction)btnRestart:(id)sender {
    [self prepare];
}

-(void) update {
    
    
    // If countdown is more than zero, just update the label text and wait for another time lapse
    if(self.countdown > 0){
        self.countdownLabel.text = [NSString stringWithFormat:@"%d", self.countdown];
        self.countdown -= 1;
        return;
        
    // If countdown is zero, we hide the countdown label and reset the timer to new timer for game interval
    } else if (self.countdown == 0) {
        self.countdownLabel.hidden = YES;
        [self.timer invalidate];
        
        float speed;
        
        switch ([_defaults integerForKey:@"speed"]) {
            
            case 0:
                speed = 0.3;
                break;
            case 2:
                speed = 0.15;
                break;
            default:
                speed = 0.2;
                break;
        }
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(update) userInfo:nil repeats:YES];
        self.countdown = -1;
        return;
    }
    
    // If game is not running (we get the status from GridCell), which mean the user was lost
    // so we stop the timer and display alert popup
    // and stop executing right away
    
    if(![self.gridCell isRunning]){
        [self.timer invalidate];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oh no, you died!" message:[NSString stringWithFormat:@"You scored %@.\nPlease insert your name", self.score.text] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
        return;
    }
    
    // Game running on
    // move the morm for each time interval
    [self.gridCell moveWorm];
    
    // Remove the old subview
    for(UIView *subView in [self.gridView subviews]){
        [subView removeFromSuperview];
    }
    
    // And add the new one. At the same time, we update the score label
    [self.gridView addSubview:[self.gridCell gridImage]];
    self.score.text = [NSString stringWithFormat:@"%d", self.gridCell.score];
}

-(void)prepare{
    
    [self.timer invalidate];
    
    // Remove all subview
    for(UIView *subView in [self.gridView subviews]){
        [subView removeFromSuperview];
    }
    
    // Initialize GridCell Object
    self.gridCell = [[GridCell alloc] init];
    
    // Initially Grid will be blurred. So make a new copy of gridcell, and manipulated it's opacity
    // Then assign as initial subview
    UIView *initScreen = [self.gridCell gridImage];
    initScreen.alpha = 0.2;
    [self.gridView addSubview:initScreen];
    
    // Add countdown label to it
    self.countdownLabel.text = @"Ready";
    self.countdownLabel.hidden = NO;
    [self.gridView addSubview:self.countdownLabel];
    
    // Set countdown starting number
    // Then start the countdown by calling update for every 1 second
    self.countdown = 3;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _defaults = [NSUserDefaults standardUserDefaults];
    self.backButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:151.0/255.0 blue:255.0/255.0 alpha:1.0];
    self.resetButton.backgroundColor = [UIColor redColor];
    
    [self prepare];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // Get user name from alert box
    NSString *userName = [[alertView textFieldAtIndex:0] text];
    
    // Get object archive
    NSMutableArray *scores = [NSKeyedUnarchiver unarchiveObjectWithFile:[_defaults stringForKey:@"score_path"]];
    if(scores == nil) scores = [[NSMutableArray alloc] init];
    
    // Add new score to the scores object
    [scores addObject:[NSArray arrayWithObjects:userName, [NSString stringWithFormat:@"%d", self.gridCell.score], nil]];
    
    // Save back to archive
    [NSKeyedArchiver archiveRootObject:scores toFile:[_defaults stringForKey:@"score_path"]];
    
    // Push to High Score view
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITableViewController *viewController = (UITableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"highscore"];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if( [inputText length] >= 2 ) return YES;
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillDisappear:animated];
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
