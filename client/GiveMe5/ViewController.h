//
//  ViewController.h
//  GiveMe5
//
//  Created by Wang JZ on 13-11-10.
//  Copyright (c) 2013年 Wang JZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    NSDictionary *local_players_dic;
    IBOutlet UIImageView *playerImageView;//选手的图片
    IBOutlet UIView *status_view;//状态栏视图
    IBOutlet UILabel *player_name_label;
    IBOutlet UILabel *score_label;//显示在右上角的分数
    int current_score;//评委当前给出的评分
    int current_player_id;//当前正在比赛的选手
}
@property(nonatomic,retain) IBOutlet UIView *status_view;
@property(nonatomic,retain) IBOutlet UIImageView *playerImageView;
@property(nonatomic,retain) IBOutlet UILabel *score_label,*player_name_label;
@property(nonatomic,retain) NSDictionary *local_players_dic;
/*点击0~9分数按钮，sender代表按钮的tag*/
-(IBAction)clickNumber:(UIButton *)sender;

/*获取当前选手的id*/
-(IBAction)get_current_player;

/*发送得分*/
-(IBAction)send_score;

/**同步get请求**/
-(void)sync_get_request:(NSString *)stringurl;

@end
