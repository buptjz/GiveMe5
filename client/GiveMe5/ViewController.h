//
//  ViewController.h
//  GiveMe5
//
//  Created by Wang JZ on 13-11-10.
//  Copyright (c) 2013年 Wang JZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    IBOutlet UIImageView *playerImageView;
    IBOutlet UILabel *score_label;
    int current_score;
}
@property(nonatomic,retain) IBOutlet UIImageView *playerImageView;
@property(nonatomic,retain) IBOutlet UILabel *score_label;


-(IBAction)clickNumber:(UIButton *)sender;
-(IBAction)refresh:(UIButton *)sender;

/**同步get请求**/
-(void)sync_get_request:(NSString *)stringurl;

@end
