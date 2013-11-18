//
//  Header.h
//  GiveMe5
//
//  Created by Wang JZ on 13-11-10.
//  Copyright (c) 2013年 Wang JZ. All rights reserved.
//

#ifndef GiveMe5_Header_h
#define GiveMe5_Header_h

//每台iPad机器上JID唯一
//1 小白
//2 小红
//3 老pad
//4 暖同学
//5 新伙伴
#define MYJID @"3"

//使用哪一个配置文件？
#define PLAY_CONFIG @"players_info_final"
//ip地址需要替换，端口不需要替换
#define IPADD @"http://192.168.1.100:8000/"

#define SENDSCORE @"display/send_score?"
#define GETCURRENTPLAYER @"display/get_current_player?"

#define SUCEESRATE @"succesrate"
#define CURRENTPLAYERPREFIX @"currentplayerid"
//http://127.0.0.1:8000/display/send_score?score=90&name=wjz
//http://127.0.0.1:8000/display/get_current_player?jid=2


#endif
