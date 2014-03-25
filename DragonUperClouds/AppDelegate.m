//
//  AppDelegate.m
//  DragonUperClouds
//
//  Created by AngerDragon on 14-1-2.
//  Copyright (c) 2014年 AngerDragon. All rights reserved.
//

#import "AppDelegate.h"
#import "YLRootNav.h"
#import "YLVC.h"
#import <Frontia/Frontia.h>
#import "Base64.h"

//这个静态是每次生命周期内最大重试下载次数是10次
static int MAX_COUNT=0;
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initBaiduAccount];
    [self initTheAccount];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    YLVC * rootVC = [[YLVC alloc]init];
    YLRootNav * rootNav = [[YLRootNav alloc]initWithRootViewController:rootVC];
    self.window.rootViewController = rootNav;
    

    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                alert_alam(@"当前网络不可用", @"当前无网络，将不会进行任何上传下载行为");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                alert_alam(@"当前是WIFI链接", @"WIFI下可以放心的上传、更新数据库，不会有额外费用");
                [self downloadRemoteFileFromBaidu];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                alert_alam(@"当前是通过收手机网络", @"当前手机网络下上传、更新数据库会产生额外费用，将关闭所有产生流量的功能");
                break;
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    return YES;
}

#pragma mark- 下载百度服务器的文件
-(void)downloadRemoteFileFromBaidu
{
    FrontiaStorage *storage = [Frontia getStorage];
    FrontiaFile *file = [FrontiaFile new];
    file.fileName = @"配置/配置文件.plist";//云存储上的路径
    FrontiaStorageFailureCallback failureCallback = ^(int errorCode, NSString *errorMessage){
        //当前在WIFI环境下，如果下载失败，将继续重试，重试次数是10次
        MAX_COUNT++;
        if (MAX_COUNT<=10) {
            [self downloadRemoteFileFromBaidu];
        }
    };
    
    FrontiaStorageFileUploadCallback simpleCallback = ^(FrontiaFile* file){
        NSLog(@"下载成功");
        [file.content writeToFile:[NSString plistFilePath] atomically:YES];
    };
    
    [storage downloadFile:file statusListener:^(NSString *file, long bytes, long total) {
    } resultListener:simpleCallback failureListener:failureCallback];
}


#pragma mark - 初始账户
-(void)initTheAccount
{
    //超级管理员密码
    if ([UserDefaults valueForKey:SuperPerson]) {
        
        
        
    }else
    {
        
        NSString * password1 =  SuperPasswordOne;
        NSString * password2 =  SuperPasswordTwo;
        NSArray * passwordArray = @[[password1 base64EncodedString],[password2 base64EncodedString]];
        
        [UserDefaults setValue:passwordArray forKey:SuperPerson];
        [UserDefaults synchronize];
    }
    
    
    //普通管理员密码
    if ([UserDefaults valueForKey:NormalPreson]) {
        
        
        
    }else
    {
        NSString * normalePassword =  NormalePassword;
        
        [UserDefaults setValue:[normalePassword base64EncodedString] forKey:NormalPreson];
        [UserDefaults synchronize];
    }

    
}


#pragma mark- 初始百度账户
-(void)initBaiduAccount
{
    #define APP_KEY @"pqZv84rs9sB62WIAd5zuxqYw"   //你自己的应用api key
    
    [Frontia initWithApiKey:APP_KEY];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
