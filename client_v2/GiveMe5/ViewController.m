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
#import "Reachability.h"

@interface ViewController (){
    CAAnimationGroup *m_pGroupAnimation;
}
@end

@implementation ViewController
@synthesize current_player_id;
@synthesize playerImageView,nameImageView,status_view,huojuImageView;
@synthesize score_label,local_players_dic,player_name_label,message_label;
@synthesize b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b_dot;
@synthesize b_confirm,b_clear,b_nextPlayer;
@synthesize productsListData;


#pragma mark --
#pragma mark 确认键

/*当评委发送得分成功后，锁定确认按键*/
-(void)lock_confirm_button{
    [UIView animateWithDuration:0.24 delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         self.b_confirm.alpha = 0.0;
                         self.huojuImageView.transform = CGAffineTransformMakeScale(1.4, 1.4);
                         self.huojuImageView.center = CGPointMake(836, 458);
                     }
                     completion:^(BOOL finished){
                         [self.b_confirm setHidden:YES];
                         [self.b_confirm setEnabled:NO];
                     }
     ];
}
/*当评委更新选手后，解锁确认按键*/
-(void)unlock_confirm_button{
    [self.b_confirm setHidden:NO];
    [UIView animateWithDuration:0.24 delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         self.b_confirm.alpha = 1.0;
                         self.huojuImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         self.huojuImageView.center = CGPointMake(904, 486);
                     }
                     completion:^(BOOL finished){
                         [self.b_confirm setEnabled:YES];
                     }
     ];
}


#pragma mark --
#pragma mark 网络

/*异步请求接口*/
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.productsListData = [NSMutableData data];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [productsListData appendData:data];

}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
    [self show_status:@"【温馨提示】网络连接异常，请于工作人员联系"];
    [connection release];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    [connection release];
    
    NSString *ret_str = [[NSString alloc]initWithData:self.productsListData encoding:NSUTF8StringEncoding];
    NSLog(@"data is :%@",ret_str);
    
    /*处理接收到当前选手编号 currentplayerid:1*/
    if([ret_str hasPrefix:CURRENTPLAYERPREFIX]){
        //如果获取到得下一位选手跟本地选手一致，那么不做处理
        NSString *ret_id = [ret_str componentsSeparatedByString:@":"][1];
        if ( [ret_id isEqual:self.current_player_id]) {
            [self show_status:@"【温馨提示】下一位选手尚未登场，请稍后再试"];
        }else{
            //如果获取到下一位选手，那么提示、清零、解锁确认键
            self.current_player_id = ret_id;
            [self set_player_info:current_player_id];
            [self show_status:@"【温馨提示】获取当前选手成功！"];
            [self clear_score];//获取一个新的选手之后，得分清零
            [self unlock_confirm_button];
        }

    }
    
    /*处理“评分成功”*/
    else if([ret_str hasPrefix:SUCEESRATE]){
        //[self show_status:@"【温馨提示】评分成功！"];
        [self lock_confirm_button];
    }
    
    /*处理其他情况*/
    else{
        NSLog(@"%@",ret_str);
        [self show_status:@"【温馨提示】网络异常，请于工作人员联系"];
    }
  
    [ret_str release];

    
}
/*使用Reachability判断是否有网络*/
-(bool)is_wifi_work
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            NSLog(@"没有网络");
            return NO;
        case ReachableViaWWAN:
            // 使用3G网络
            NSLog(@"正在使用3G网络");
            return YES;
        case ReachableViaWiFi:
            // 使用WiFi网络
            NSLog(@"正在使用wifi网络");
            return YES;
    }
}




/*异步get请求*/
-(void)unsync_get_request:(NSString *)stringurl
{
    NSLog(@"【开始 网络 请求】%@",stringurl);
    
    //NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:stringurl]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:stringurl]
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:7];//设置7秒的网络超时时限
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    if (theConnection) {

    }else{
    
    }
}

#pragma mark --
#pragma mark 选手
/*设置界面，包括选手名字和图片*/
-(void)set_player_info:(NSString *)player_id{
    NSDictionary *player_dic = [local_players_dic objectForKey:player_id];
    
    //修改名字图片
    NSString *name_img = [player_dic objectForKey:@"name_image"];
    NSString *name_img_file = [[NSBundle mainBundle] pathForResource:name_img ofType: @"png"];
    [nameImageView setImage:[UIImage imageWithContentsOfFile:name_img_file]];
    
    //修改选手图片
    NSString *play_img = [player_dic objectForKey:@"image"];
    NSString *img_file = [[NSBundle mainBundle] pathForResource:play_img ofType: @"png"];
    [playerImageView setImage:[UIImage imageWithContentsOfFile:img_file]];
    
    //    //修改名字
    //    NSString *play_name = [player_dic objectForKey:@"name"];
    //    [player_name_label setText:play_name];
    
}

/*获取当前选手的id，需要处理返回值,返回“currentplayerid:1”这类的*/
-(IBAction)get_current_player{
    NSLog(@"【按键】下一位选手");
    //http://127.0.0.1:8000/display/get_current_player?jid=2
    NSString *url = [NSString stringWithFormat:@"%@%@jid=%@",IPADD,GETCURRENTPLAYER,MYJID];
    [self unsync_get_request:url];
}

#pragma mark --
#pragma mark 得分

/*更新显示得分*/
-(void)update_score_display:(struct player_score)score{
    float display_score = score.left_digit+score.right_digit/10.0;
    self.score_label.text = [NSString stringWithFormat:@"%.1f",display_score];
}

/*发送得分，返回值'true' 或者 'false'*/
-(IBAction)send_score{
    NSLog(@"【按键】确认");
    //http://127.0.0.1:8000/display/send_score?jid=1&pid=2&score=90
    float score = my_current_score.left_digit+my_current_score.right_digit/10.0;
    NSString *url = [NSString stringWithFormat:@"%@%@jid=%@&pid=%@&score=%.1f",
                     IPADD,SENDSCORE,MYJID,current_player_id,score];
    [self unsync_get_request:url];
}
/*得分清零*/
-(void)clear_score{
    my_current_score.left_digit = 0;
    my_current_score.right_digit = 0;
    my_current_score.has_touched = NO;
    [self update_score_display:my_current_score];
}
/*点击0~9得分按钮，sender代表按钮的tag*/
-(IBAction)clickNumber:(UIButton *)sender
{
    if (sender.tag == 11) {//点
        NSLog(@"【按键】.");
        my_current_score.has_touched = YES;
    }else if (sender.tag == 31){//清零
        NSLog(@"【按键】清零");
        [self clear_score];
        
    }else{//数字
        NSLog(@"【按键】%d",sender.tag);
        //如果左侧还没有数字，那么设置该数字在左
        if (!my_current_score.has_touched) {
            my_current_score.left_digit = sender.tag;
            my_current_score.right_digit = 0;
            my_current_score.has_touched = YES;
        }else{//如果左侧有数字了，那么设置该数字在右上
            my_current_score.right_digit = sender.tag;
        }
        [self update_score_display:my_current_score];
    }

}

#pragma mark --
#pragma mark 界面状态

/*状态栏提示，渐现渐隐，然后隐藏掉*/
-(void)show_status:(NSString *)message{
    [message_label setText:message];
    //
    [UIView animateWithDuration:1.2 delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         self.status_view.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:1.2 delay:1.0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^ {
                                              self.status_view.alpha = 0.0;
                                          }
                                          completion:^(BOOL finished) {
                                          }
                          ];
                     }
     ];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    current_player_id = [[NSString alloc]init];//当前id
    self.current_player_id = @"1";//defalut value of 当前选手id
    
    [self clear_score];//初始化socre

    //读取本地保存的选手图片
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"players_info" ofType:@"plist"];
    local_players_dic= [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    [status_view setAlpha:0];//status_view一开始并不显示
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
