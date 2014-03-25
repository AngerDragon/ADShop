//
//  YLGlobal.m
//  DragonUperClouds
//
//  Created by AngerDragon on 14-1-2.
//  Copyright (c) 2014年 AngerDragon. All rights reserved.
//

#import "YLGlobal.h"

@implementation YLGlobal


-(id)init
{
    if (self == [super init]) {
        
        //默认是访客身份
        self.currentPersonType = 2;
    }
    
    return self;
}



+(YLGlobal *)global
{
    
    static YLGlobal * global = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        global = [self new];
    });
    
    return global;
}





@end
