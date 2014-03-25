//
//  YLLoginVC.m
//  DragonUperClouds
//
//  Created by AngerDragon on 14-1-2.
//  Copyright (c) 2014年 AngerDragon. All rights reserved.
//

#import "YLLoginVC.h"
#import "Base64.h"

@interface YLLoginVC ()

@property(nonatomic,copy)NSString * inputPasswordText;

@property(nonatomic,weak)UITextField * field;

@end

@implementation YLLoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.inputPasswordText = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem * cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    
    UITableView * loginTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    loginTableView.backgroundColor = [UIColor clearColor];
    loginTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    loginTableView.delegate = self;
    loginTableView.dataSource = self;
    [self.view addSubview:loginTableView];
    
    
    loginTableView.tableHeaderView = ({
        UILabel * headerView = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(loginTableView.bounds), CGRectGetMinY(loginTableView.bounds), CGRectGetWidth(loginTableView.bounds), 70)];
        headerView.backgroundColor = [UIColor clearColor];
        headerView.textAlignment = NSTextAlignmentCenter;
        headerView.font = [UIFont boldSystemFontOfSize:20];
        headerView.text = @"请输入管理员密码";
        
        headerView;
    });
    
    loginTableView.tableFooterView = ({
        
        UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(CGRectGetMinX(loginTableView.bounds), CGRectGetMinY(loginTableView.bounds), CGRectGetWidth(loginTableView.bounds), 60);
        [loginButton setTitle:@"登录" forState:UIControlStateNormal];
        loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
        [loginButton addTarget:self action:@selector(loginPressed) forControlEvents:UIControlEventTouchUpInside];
        
        loginButton;
        
    });
    
}



#pragma mark- 取消按下
-(void)cancelPressed
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - 登录键按下
-(void)loginPressed
{
    if ([self.field isFirstResponder]) {
        [self.field resignFirstResponder];
    }
    NSArray *superPasswords = [UserDefaults valueForKey:SuperPerson];
    NSString *normalPassword = [UserDefaults valueForKey:NormalPreson];
    
    if (self.inputPasswordText.length > 0) {
        self.inputPasswordText = [self.inputPasswordText base64EncodedString];
        if ([superPasswords containsObject:self.inputPasswordText]) {
            if (self.loginBlock) {
                //超级管理员登录
                self.loginBlock(YES,superPerson);
            }
        }else
        {
            if ([normalPassword isEqualToString:self.inputPasswordText]) {
                if (self.loginBlock) {
                    //普通管理员登录
                    self.loginBlock(YES,normalPerson);
                }
            }else
            {
                if (self.loginBlock) {
                    //密码错误，游客
                    self.loginBlock(YES,guest);
                }
            }
        }
    }else
    {
        alert_alam(@"请输入密码", @"您没有输入任何内容，请输入密码");

    }
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndetify = @"cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndetify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UITextField * field = [[UITextField alloc]initWithFrame:cell.contentView.bounds];
    self.field = field;
    field.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    field.delegate = self;
    field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.placeholder = @"点击这里输入密码";
    field.returnKeyType = UIReturnKeyGo;
    field.keyboardType = UIKeyboardTypeNumberPad;
    field.secureTextEntry = YES;
    [cell.contentView addSubview:field];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.field isFirstResponder]) {
        [self.field becomeFirstResponder];
    }

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.text.length > 0) {
        self.inputPasswordText = textField.text;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0) {
        [self loginPressed];
    }else
    {
        alert_alam(@"请输入密码", @"您没有输入任何内容，请输入密码");
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
