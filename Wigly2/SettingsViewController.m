//
//  SettingsViewController.m
//  Wigly2
//
//  Created by Faiz Shukri on 11/8/14.
//  Copyright (c) 2014 Faiz Shukri. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults boolForKey:@"saveFirst"]){
        [self resetDefault:self];
    }
    
    [self updateSetting];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) resetDefault:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:1 forKey:@"speed"];
    [defaults setBool:YES forKey:@"sound"];
    [defaults setInteger:5 forKey:@"wormhole"];
    [self updateSetting];
    
    [defaults setBool:YES forKey:@"saveFirst"];
}

-(IBAction) saveDefault:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger segmentIndex = [self.speedControl selectedSegmentIndex];
    [defaults setInteger:segmentIndex forKey:@"speed"];
    [defaults setBool:self.soundButton.on forKey:@"sound"];
    [defaults setInteger:[self.wormholeText.text integerValue] forKey:@"wormhole"];
}

-(void) updateSetting {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self.speedControl setSelectedSegmentIndex:[defaults integerForKey:@"speed"]];
    self.soundButton.on = [defaults boolForKey:@"sound"];
    self.wormholeText.text = [NSString stringWithFormat:@"%d", [defaults integerForKey:@"wormhole"]];
    self.wormholeStepper.value = [defaults floatForKey:@"wormhole"];
}

-(IBAction)stepperPressed:(id)sender {
    self.wormholeText.text = [NSString stringWithFormat:@"%1.0f", self.wormholeStepper.value];
}

@end
