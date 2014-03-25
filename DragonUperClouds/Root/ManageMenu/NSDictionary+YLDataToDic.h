//
//  NSDictionary+YLDataToDic.h
//  DragonUperClouds
//
//  Created by AngerDragon on 14-1-7.
//  Copyright (c) 2014年 AngerDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YLDataToDic)

+ (NSDictionary *)dictionaryWithContentsOfData:(NSData *)data;

@end
