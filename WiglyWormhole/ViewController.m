//
//  ViewController.m
//  Wigly2
//
//  Created by Faiz Shukri on 11/6/14.
//  Copyright (c) 2014 Faiz Shukri. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *archivePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"score.archive"];
    [_defaults setValue:archivePath forKey:@"score_path"];
    
    if(![_defaults boolForKey:@"saveFirst"]){
        self.settings = [[SettingsViewController alloc] init];
        [self.settings resetDefault:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillDisappear:animated];
}

@end
