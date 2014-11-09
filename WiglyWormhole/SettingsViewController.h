//
//  SettingsViewController.h
//  Wigly2
//
//  Created by Faiz Shukri on 11/8/14.
//  Copyright (c) 2014 Faiz Shukri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *speedControl;
@property (weak, nonatomic) IBOutlet UISwitch *soundButton;
@property (weak, nonatomic) IBOutlet UIStepper *wormholeStepper;
@property (weak, nonatomic) IBOutlet UITextField *wormholeText;

-(IBAction)stepperPressed:(id)sender;
-(IBAction)saveDefault:(id)sender;
-(IBAction)resetDefault:(id)sender;
-(void) updateSetting;
@end
