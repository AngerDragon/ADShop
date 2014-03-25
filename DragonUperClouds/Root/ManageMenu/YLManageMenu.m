//
//  YLManageMenu.m
//  DragonUperClouds
//
//  Created by AngerDragon on 14-1-6.
//  Copyright (c) 2014年 AngerDragon. All rights reserved.
//

#import "YLManageMenu.h"
#import <Frontia/Frontia.h>
#import <Frontia/FrontiaStorage.h>
#import <Frontia/FrontiaFile.h>
#import "NSDictionary+YLDataToDic.h"
#import "YLChagePasswordVC.h"

@interface YLManageMenu ()

@property(nonatomic,strong)NSArray * menuArray;

@end

@implementation YLManageMenu

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        switch ([[YLGlobal global] currentPersonType]) {
            case 0:
                self.menuArray = @[@"查进价",@"查进货单信息",@"新增一条进价",@"新增进货单信息",@"修改密码",@"上传本地配置文件(需要网络)",@"上传本地进货信息(需要网络)"];
                break;
                
            case 1:
                self.menuArray = @[@"",@"查进价",@"查进货单信息",@"上传本地配置文件(需要网络)",@"上传本地进货信息(需要网络)"];
                break;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UITableView * menuTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    menuTableView.backgroundColor = [UIColor clearColor];
    menuTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    menuTableView.bounces = NO;
    menuTableView.alwaysBounceVertical = NO;
    menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    menuTableView.delegate = self;
    menuTableView.dataSource = self;
    [self.view addSubview:menuTableView];
    
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndentify = @"cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = self.menuArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([[YLGlobal global] currentPersonType]) {
            
        case 0:
            
            if (indexPath.row == 4) {
                [self chagePasswordForSuperAndmistor];
            }
            
            if (indexPath.row == 5) {
                if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
                    if ([[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]) {
                        [self uploadLocalFielToBaidu];
                    }else
                    {
                        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"当前非WIFI" message:@"现在非WIFI环境下，上传会花流量钱的，确定么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定更新", nil];
                        [alertView show];
                        [alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *x) {
                            if ([x isEqualToNumber:[NSNumber numberWithInteger:0]]) {
                                
                            }else
                            {
                                
                                [self uploadLocalFielToBaidu];
                            }
                        }];
                        
                    }
                    
                }else
                {
                    alert_alam(@"无网络连接", @"当前无网络连接，无法下载更新数据,请连接至WIFI");
                }
                
            }
            
            break;
            
        case 1:
            
            if (indexPath.row == 3) {
                if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
                    if ([[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]) {
                        [self uploadLocalFielToBaidu];
                    }else
                    {
                        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"当前非WIFI" message:@"现在非WIFI环境下，上传会花流量钱的，确定么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定更新", nil];
                        [alertView show];
                        [alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *x) {
                            if ([x isEqualToNumber:[NSNumber numberWithInteger:0]]) {
                                
                            }else
                            {
                                
                                [self uploadLocalFielToBaidu];
                            }
                        }];
                        
                    }
                }
            }
            break;
            
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark- 修改密码
-(void)chagePasswordForSuperAndmistor
{
    YLChagePasswordVC * changeVC = [[YLChagePasswordVC alloc]init];
    YLRootNav * nav = [[YLRootNav alloc]initWithRootViewController:changeVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark- 上传至百度
-(void)uploadLocalFielToBaidu
{
    MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:self.view title:@"上传中" mode:MRProgressOverlayViewModeDeterminateCircular animated:YES];
    
    FrontiaStorage *storage = [Frontia getStorage];
    FrontiaStorageFailureCallback failureCallback = ^(int errorCode, NSString *errorMessage){
        NSLog(@"失败了---%@",errorMessage);
        progressView.titleLabelText = @"上传失败";
        [progressView dismiss:YES];

    };
    FrontiaStorageFileUploadCallback simpleCallback = ^(FrontiaFile* file){
        NSLog(@"成功了---%@",file);
        progressView.progress = 1.0f;
        progressView.titleLabelText = @"上传成功";
        [progressView dismiss:YES];

    };
    
    NSData * data = [NSData dataWithContentsOfFile:[NSString plistFilePath]];
    
    FrontiaFile *file = [FrontiaFile new];
    file.fileName = @"配置/配置文件.plist";//云存储上的路径
    file.content = data;//把图片设置为FrontiaFile的内容
    
    [storage deleteFile:file resultListener:^(NSString *fileName) {
        NSLog(@"删除文件成功:%@",fileName);
        [storage uploadFile:file statusListener:^(NSString *file, long bytes, long total) {
            NSLog(@"删除文件成功后开始上传");
            float progress = (float)(bytes/total);
            progressView.progress = progress;
        } resultListener:simpleCallback failureListener:failureCallback];

    } failureListener:^(int errorCode, NSString *errorMessage) {
        NSLog(@"删除文件失败:%d %@",errorCode,errorMessage);
        [storage uploadFile:file statusListener:^(NSString *file, long bytes, long total) {
            NSLog(@"删除文件失败后开始上传");
            float progress = (float)(bytes/total);
            progressView.progress = progress;
        } resultListener:simpleCallback failureListener:failureCallback];

    }];
    

//    [storage deleteFile:file resultListener:^(NSString *fileName) {
//        [storage uploadFile:file statusListener:^(NSString *file, long bytes, long total) {
//        } resultListener:simpleCallback failureListener:failureCallback];
//
//    } failureListener:^(int errorCode, NSString *errorMessage) {
//        NSLog(@"错误:::%d %@",errorCode,errorMessage);
//    }];
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
