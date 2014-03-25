//
//  NSDictionary+YLDataToDic.m
//  DragonUperClouds
//
//  Created by AngerDragon on 14-1-7.
//  Copyright (c) 2014年 AngerDragon. All rights reserved.
//

#import "NSDictionary+YLDataToDic.h"

@implementation NSDictionary (YLDataToDic)

+ (NSDictionary *)dictionaryWithContentsOfData:(NSData *)data {
    CFPropertyListRef plist =  CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (CFDataRef)data,
                                                               kCFPropertyListImmutable,
                                                               NULL);
    if(plist == nil) return nil;
    if ([(id)plist isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)plist autorelease];
    }
    else {
        CFRelease(plist);
        return nil;
    }
}
@end
