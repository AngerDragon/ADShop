//
//  FrontiaShareContent.h
//  FrontiaShare
//
//  Created by 夏文海 on 13-9-24.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface FrontiaShareContent : NSObject
/*!
 * 分享的链接
 */
@property (nonatomic,strong) NSString *url;

/*!
 * 分享的描述
 */
@property (nonatomic,strong) NSString *description;

/*!
 * 分享的标题
 */
@property (nonatomic,strong) NSString *title;

/*!
 * 分享的图片对象
 */
@property (nonatomic,strong) UIImage *imageObj;

/*!
 * 分享的图片链接地址
 */
@property (nonatomic,strong) NSString *imageUrl;

/*!
 * 是否单纯分享图片到第三方客户端
 */
@property (nonatomic,assign) BOOL isShareImageToApp;

/*!
 * 地理位置信息
 */
@property (nonatomic,strong) CLLocation *locationInfo;

@end
