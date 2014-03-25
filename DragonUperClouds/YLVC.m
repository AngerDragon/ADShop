//
//  YLVC.m
//  DragonUperClouds
//
//  Created by AngerDragon on 14-1-2.
//  Copyright (c) 2014年 AngerDragon. All rights reserved.
//

#import "YLVC.h"
#import "YLLoginVC.h"
#import "YLScanVC.h"
#import "YLScanNavVC.h"
#import "YLManageMenu.h"
#import "NSDictionary+YLDataToDic.h"

@interface YLVC ()

@property(nonatomic,strong)NSArray * menuListArray;

@property(nonatomic,unsafe_unretained)YLRootNav * loginNav;
@end

@implementation YLVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.menuListArray = @[@"扫价格",@"查价格",@"管理中心",@"更新配置文件(需要网络)"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    UITableView * menuTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    menuTableView.backgroundColor = [UIColor redColor];
    menuTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    menuTableView.bounces = NO;
    menuTableView.alwaysBounceVertical = NO;
    menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    menuTableView.delegate = self;
    menuTableView.dataSource = self;
    [self.view addSubview:menuTableView];
    
    
    menuTableView.tableHeaderView = ({
        
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(menuTableView.bounds), CGRectGetMinY(menuTableView.bounds), CGRectGetWidth(menuTableView.bounds), 100)];
        headerView.backgroundColor = [UIColor orangeColor];
        
        headerView;
    });
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuListArray.count;
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
    cell.textLabel.text = self.menuListArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        YLScanVC * scanVC = [[YLScanVC alloc]init];
        YLScanNavVC * scanNav = [[YLScanNavVC alloc]initWithRootViewController:scanVC];
        scanNav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:scanNav animated:YES completion:^{
            
        }];
        
        scanVC.resultBlock = ^(NSString *scanResult,NSString *scanType){
            [scanNav dismissViewControllerAnimated:YES completion:^{
                NSLog(@"扫描的结果是:%@ 扫描的类型是:%@",scanResult,scanType);
            }];
            
        };
        
        scanVC.cancelBlock = ^(){
            [scanNav dismissViewControllerAnimated:YES completion:^{
                
            }];
        };
        
    }
    
    
    if (indexPath.row == 2) {
        YLLoginVC * login = [[YLLoginVC alloc]init];
        login.loginBlock = ^(BOOL success,PersonType type){
            if (success) {
                [[YLGlobal global]setCurrentPersonType:type];
                
                switch (type) {
                    case superPerson:
                        alert_alamWithTag(@"超级管理员登录", @"欢迎您，超级管理员", nil, @"确定", @"61332");
                        break;
                        
                    case normalPerson:
                        alert_alamWithTag(@"管理员登录", @"欢迎您，管理员", nil, @"确定", @"61332");
                        break;
                        
                    case guest:
                        alert_alam(@"密码输入不匹配", @"密码输入不匹配，请重新输入");
                        break;
                }}else
                {
                    alert_alam(@"没有登录成功", @"您输入的密码不匹配，请重新输入");
                }
            
        };
        YLRootNav * loginNav = [[YLRootNav alloc]initWithRootViewController:login];
        self.loginNav = loginNav;
        loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:loginNav animated:YES completion:^{
            
        }];
    }
    
    if (indexPath.row == 3) {
        if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
            if ([[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]) {
                [self downloadRemoteFileFromBaidu];
            }else
            {
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"当前非WIFI" message:@"现在非WIFI环境下，更新会花流量钱的，确定么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定更新", nil];
                [alertView show];
                [alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *x) {
                    if ([x isEqualToNumber:[NSNumber numberWithInteger:0]]) {
                        
                    }else
                    {
                        
                        [self downloadRemoteFileFromBaidu];
                    }
                }];
                
            }
            
        }else
        {
            alert_alam(@"无网络连接", @"当前无网络连接，无法下载更新数据,请连接至WIFI");
        }
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark- 下载百度服务器的文件
-(void)downloadRemoteFileFromBaidu
{
    MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:self.view title:@"下载中" mode:MRProgressOverlayViewModeDeterminateCircular animated:YES];

    FrontiaStorage *storage = [Frontia getStorage];
    FrontiaFile *file = [FrontiaFile new];
    file.fileName = @"配置/配置文件.plist";//云存储上的路径
    FrontiaStorageFailureCallback failureCallback = ^(int errorCode, NSString *errorMessage){
        NSLog(@"下载失败了---%@",errorMessage);
        progressView.titleLabelText = @"下载失败";
        [progressView dismiss:YES];
    };
    
    FrontiaStorageFileUploadCallback simpleCallback = ^(FrontiaFile* file){
        NSLog(@"下载成功了---%@",file);
        progressView.progress = 1.0f;
        progressView.titleLabelText = @"下载成功";
        [progressView dismiss:YES];
        [file.content writeToFile:[NSString plistFilePath] atomically:YES];
    };
    
    [storage downloadFile:file statusListener:^(NSString *file, long bytes, long total) {
        float progress = (float)(bytes/total);
        progressView.progress = progress;
    } resultListener:simpleCallback failureListener:failureCallback];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag ==61332) {
        if (buttonIndex == 0) {
            YLManageMenu * manageMenuVC = [[YLManageMenu alloc]init];
            [self.loginNav dismissViewControllerAnimated:YES completion:^{
                [self.navigationController pushViewController:manageMenuVC animated:YES];
            }];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
