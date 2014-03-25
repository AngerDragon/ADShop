//
//  YLLoginVC.h
//  DragonUperClouds
//
//  Created by AngerDragon on 14-1-2.
//  Copyright (c) 2014年 AngerDragon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    superPerson     =0,
    normalPerson    =1,
    guest           =2,
}PersonType;
typedef void (^YLLoginSuccess)(BOOL success,PersonType type);

@interface YLLoginVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,copy)YLLoginSuccess loginBlock;

@end
