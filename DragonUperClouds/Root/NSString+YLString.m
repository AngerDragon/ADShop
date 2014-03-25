//
//  NSString+YLString.m
//  DragonUperClouds
//
//  Created by AngerDragon on 14-1-6.
//  Copyright (c) 2014年 AngerDragon. All rights reserved.
//

#import "NSString+YLString.h"

@implementation NSString (YLString)

+(NSString *)getCurrentPlistName
{
    NSString * bundle = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey];
    return bundle;
}


+(NSString *)plistFilePath
{
    NSString * fileName = [NSString stringWithFormat:@"%@.plist",[NSString getCurrentPlistName]];
    
    NSString * detail = [NSString stringWithFormat:@"%@/Preferences/%@",fileNameBySelf,fileName];
    
    return detail;
    
    
}

@end
