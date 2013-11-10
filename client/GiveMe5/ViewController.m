//
//  ViewController.m
//  GiveMe5
//
//  Created by Wang JZ on 13-11-10.
//  Copyright (c) 2013年 Wang JZ. All rights reserved.
//

#import "ViewController.h"
#import "constant.h"

@interface ViewController ()
@end

@implementation ViewController
@synthesize playerImageView;
@synthesize score_label;

/**同步get请求**/
-(void)sync_get_request:(NSString *)stringurl
{
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:stringurl];
    //第二步，通过URL创建网络请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:10];
    //第三步，连接服务器,发送同步请求
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *ret_str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    NSLog(@"data is :%@",ret_str);
}

-(IBAction)refresh:(UIButton *)sender{
    NSString *url = [NSString stringWithFormat:@"%@score=%d&name=%@",SERVERURL,20,@"wangjizhe"];
    [self sync_get_request:url];
}
-(IBAction)clickNumber:(UIButton *)sender
{
    current_score = sender.tag;
    self.score_label.text = [NSString stringWithFormat:@"%d",sender.tag];
    
    //temp
    //http://127.0.0.1:8000/display/send_score?score=90&name=wjz
    NSString *url = [NSString stringWithFormat:@"%@score=%d&name=%@",SERVERURL,sender.tag,@"wangjizhe"];
    [self sync_get_request:url];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    current_score = 9;//defalut value of current score
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//重载shouldAutorotateToInterfaceOrientation:方法，这种方式是可行的。具体如下：
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return ((interfaceOrientation ==UIDeviceOrientationLandscapeLeft)||(interfaceOrientation ==UIDeviceOrientationLandscapeRight));
}


@end
