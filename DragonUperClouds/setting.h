//
//  setting.h
//  DragonUperClouds
//
//  Created by AngerDragon on 14-1-2.
//  Copyright (c) 2014年 AngerDragon. All rights reserved.
//

#ifndef DragonUperClouds_setting_h
#define DragonUperClouds_setting_h


#define SuperPerson     @"超级管理员密码"
#define NormalPreson    @"普通管理员密码"

//默认超级管理员密码
#define SuperPasswordOne @"198922"
#define SuperPasswordTwo @"19900514"

//默认普通管理员密码
#define NormalePassword  @"123456"

//存储到本地
#define UserDefaults [NSUserDefaults standardUserDefaults]

//写一个警告弹出框的宏
#define alert_alam(alert_title,alert_message) {UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",alert_title] message:[NSString stringWithFormat:@"%@",alert_message] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];[alert show];}

//弹出警告带tag值
#define alert_alamWithTag(alert_title,alert_message,cancelButton,otherButton,alertTag) {UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",alert_title] message:[NSString stringWithFormat:@"%@",alert_message] delegate:self cancelButtonTitle:cancelButton otherButtonTitles:otherButton, nil];alert.tag=[alertTag integerValue];[alert show];}

//缓存地址
#define fileNameBySelf [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]
//下面的两张图用在修改密码时，是否符合要求
#define  Wrong        [UIImage imageNamed:@"checkbox"]
#define  Right        [UIImage imageNamed:@"checkSelected"]


#endif
