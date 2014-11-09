//
//  ViewController.h
//  Wigly2
//
//  Created by Faiz Shukri on 11/6/14.
//  Copyright (c) 2014 Faiz Shukri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

@interface ViewController : UIViewController {
    NSUserDefaults *_defaults;
}

@property SettingsViewController *settings;

@end

