//
//  YLScanVC.m
//  DragonUperClouds
//
//  Created by AngerDragon on 14-1-6.
//  Copyright (c) 2014年 AngerDragon. All rights reserved.
//

#import "YLScanVC.h"
#import "UIScannerView.h"
@interface YLScanVC ()

@property(nonatomic,strong)UIScannerView *scanView;

@end

@implementation YLScanVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem * cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
    self.navigationItem.leftBarButtonItem = cancel;
    self.title = @"扫描条形码查价格";
    
    self.scanView = [[UIScannerView alloc]initWithFrame:self.view.bounds];
    self.scanView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.scanView.backgroundColor = [UIColor clearColor];
    [self.scanView setVerboseLogging:YES];
    self.scanView.delegate = self;
    [self.scanView startCaptureSession];
    [self.scanView startScanSession];
    [self.view addSubview:self.scanView];
    
    
    
}

#pragma mark- 按下取消键后
-(void)cancelPressed
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark- 扫描代理
- (void)didScanCode:(NSString *)scannedCode onCodeType:(NSString *)codeType {

    if (self.resultBlock) {
        self.resultBlock(scannedCode,[self.scanView humanReadableCodeTypeForCode:codeType]);
    }
}

- (void)errorGeneratingCaptureSession:(NSError *)error {
    [self.scanView stopCaptureSession];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不支持设备" message:@"没有检测到这个设备有摄像头，请更换设备重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alert show];
    
}

- (void)errorAcquiringDeviceHardwareLock:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法对焦" message:@"点击需要对焦的位置，稍等片刻，让摄像头自动对焦" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
