//
//  YLGlobal.h
//  DragonUperClouds
//
//  Created by AngerDragon on 14-1-2.
//  Copyright (c) 2014年 AngerDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLGlobal : NSObject


/**
 *	@brief	单例
 *
 *	@return	返回自身
 */
+(YLGlobal*)global;


/**
 *	@brief	当前用户的身份
 */
@property(nonatomic,unsafe_unretained)NSUInteger currentPersonType;


@end
