//
//  ViewController.m
//  GiveMe5
//
//  Created by Wang JZ on 13-11-10.
//  Copyright (c) 2013年 Wang JZ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController
@synthesize playerImageView;
@synthesize score_label;


-(IBAction)clickNumber:(UIButton *)sender
{
    current_score = sender.tag;
    self.score_label.text = [NSString stringWithFormat:@"%d",sender.tag];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
