//
//  ViewController.h
//  GiveMe5
//
//  Created by Wang JZ on 13-11-10.
//  Copyright (c) 2013年 Wang JZ. All rights reserved.
//

#import <UIKit/UIKit.h>

struct player_score{
    int left_digit;
    int right_digit;
    float cur_score;
    bool has_touched;
};

@interface ViewController : UIViewController{
    struct player_score my_current_score;
    NSDictionary *local_players_dic;
    IBOutlet UIImageView *huojuImageView;//火炬的图片
    
    IBOutlet UIImageView *nameImageView;//选手名字的图片
    IBOutlet UIImageView *playerImageView;//选手的图片
    IBOutlet UIView *status_view;//状态栏视图
    IBOutlet UILabel *player_name_label;//选手名字
    IBOutlet UILabel *score_label;//显示在右上角的分数
    IBOutlet UILabel *message_label;//显示在右上角的分数
    IBOutlet UIButton *b0,*b1,*b2,*b3,*b4,*b5,*b6,*b7,*b8,*b9,*b_dot;//0~9 and '.'
    IBOutlet UIButton *b_confirm,*b_clear,*b_nextPlayer;//button 确认、清零、下一位

    NSString *current_player_id;//当前正在比赛的选手
    NSMutableData *productsListData;//异步请求接受数据
    

}
@property(nonatomic,retain)NSMutableData *productsListData;

@property(nonatomic,retain) NSString *current_player_id;
@property(nonatomic,retain) IBOutlet UIButton *b0,*b1,*b2,*b3,*b4,*b5,*b6,*b7,*b8,*b9,*b_dot;
@property(nonatomic,retain) IBOutlet UIButton *b_confirm,*b_clear,*b_nextPlayer;
@property(nonatomic,retain) IBOutlet UIView *status_view;
@property(nonatomic,retain) IBOutlet UIImageView *playerImageView;
@property(nonatomic,retain) IBOutlet UIImageView *nameImageView;
@property(nonatomic,retain) IBOutlet UIImageView *huojuImageView;
@property(nonatomic,retain) IBOutlet UILabel *score_label,*player_name_label,*message_label;
@property(nonatomic,retain) NSDictionary *local_players_dic;
/*点击0~9分数按钮，sender代表按钮的tag*/
-(IBAction)clickNumber:(UIButton *)sender;

/*获取当前选手的id*/
-(IBAction)get_current_player;

/*发送得分*/
-(IBAction)send_score;

/**同步get请求**/
//-(void)sync_get_request:(NSString *)stringurl;

@end
