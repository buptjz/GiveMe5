//
//  ViewController.m
//  GiveMe5
//
//  Created by Wang JZ on 13-11-10.
//  Copyright (c) 2013年 Wang JZ. All rights reserved.
//

#import "ViewController.h"
#import "constant.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@end

@implementation ViewController
@synthesize playerImageView,status_view;
@synthesize score_label,local_players_dic,player_name_label;

/*设置界面，包括选手名字和图片*/
-(void)set_player_info:(NSString *)player_id{
    NSDictionary *player_dic = [local_players_dic objectForKey:player_id];

    //修改图片
    NSString *play_img = [player_dic objectForKey:@"image"];
    NSString *img_file = [[NSBundle mainBundle] pathForResource:play_img ofType: @"jpg"];
    [playerImageView setImage:[UIImage imageWithContentsOfFile:img_file]];
    
    //修改名字
    NSString *play_name = [player_dic objectForKey:@"name"];
    [player_name_label setText:play_name];
    
}

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
    [self show_status];
    //处理接收到当前选手编号 currentplayerid:1
    if([ret_str hasPrefix:@"currentplayerid"]){
        NSString *cur_play_id = [ret_str componentsSeparatedByString:@":"][1];
        [self set_player_info:cur_play_id];
    }
}

/*发送得分，返回值'true' 或者 'false'*/
-(IBAction)send_score{
    //http://127.0.0.1:8000/display/send_score?jid=1&pid=2&score=90
    NSString *url = [NSString stringWithFormat:@"%@%@jid=%@&pid=%d&score=%d",
                     IPADD,SENDSCORE,MYJID,current_player_id,current_score];
    [self sync_get_request:url];
}
/*获取当前选手的id，需要处理返回值,返回“currentplayerid:1”这类的*/
-(IBAction)get_current_player{
    //http://127.0.0.1:8000/display/get_current_player?jid=2
    NSString *url = [NSString stringWithFormat:@"%@%@jid=%@",IPADD,GETCURRENTPLAYER,MYJID];
    [self sync_get_request:url];
}

/*点击0~9得分按钮，sender代表按钮的tag*/
-(IBAction)clickNumber:(UIButton *)sender
{
    current_score = sender.tag;
    self.score_label.text = [NSString stringWithFormat:@"%d",sender.tag];
}

/*显示发送成功，然后隐藏掉*/
-(void)show_status{
    [UIView animateWithDuration:1.2 delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         self.status_view.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:1.2 delay:0.3
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^ {
                                              self.status_view.alpha = 0.0;
                                          }
                                          completion:^(BOOL finished) {
                                          }
                          ];
                     }];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    current_score = 9;//defalut value of 当前得分
    current_player_id = 1;//defalut value of 当前选手id
    //读取本地保存的选手图片
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"players_info" ofType:@"plist"];
    local_players_dic= [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    [status_view setAlpha:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//重载shouldAutorotateToInterfaceOrientation:方法，这种方式是可行的。具体如下：
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return ((interfaceOrientation ==UIDeviceOrientationLandscapeLeft)||(interfaceOrientation ==UIDeviceOrientationLandscapeRight));
}


@end
