//
//  YLScanVC.h
//  DragonUperClouds
//
//  Created by AngerDragon on 14-1-6.
//  Copyright (c) 2014年 AngerDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScannerView.h"

typedef void (^YLScanResultBlock)(NSString *scanResult,NSString *scanType);
typedef void (^YLScanCancelBlock)();

@interface YLScanVC : UIViewController<UIScannerViewDelegate>


@property (nonatomic, copy) YLScanResultBlock resultBlock;
@property (nonatomic, copy) YLScanCancelBlock cancelBlock;

@end
