//
//  YLChagePasswordVC.m
//  DragonUperClouds
//
//  Created by AngerDragon on 14-1-7.
//  Copyright (c) 2014年 AngerDragon. All rights reserved.
//

#import "YLChagePasswordVC.h"
#import "Base64.h"

@interface YLChagePasswordVC ()

@property(nonatomic,strong)UITextField * superOldPasswordTextField;
@property(nonatomic,strong)UITextField * superNewPasswordTextField;
@property(nonatomic,strong)UITextField * normalOldPasswordTextField;
@property(nonatomic,strong)UITextField * normalNewPasswordTextField;
@property(nonatomic,strong)UIButton * superCreatButton;
@property(nonatomic,strong)UIButton * normalCreatButton;

/*------*/
@property(nonatomic,strong)RACSignal *superOldPasswordSignal;
@property(nonatomic,strong)RACSignal *superNewPasswordSignal;
@property(nonatomic,strong)RACSignal *superCourrentSignal;
/*------*/
@property(nonatomic,strong)RACSignal *normalOldPasswordSignal;
@property(nonatomic,strong)RACSignal *normalNewPasswordSignal;
@property(nonatomic,strong)RACSignal *normalCourrentSignal;



/*------*/
//cells
@property(nonatomic,strong)NSMutableDictionary * allCells;

@end

@implementation YLChagePasswordVC

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.allCells = [NSMutableDictionary dictionary];
    
    UIBarButtonItem * cancelBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChangePassword)];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    self.title = @"修改密码";
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.bounces = YES;
    tableView.alwaysBounceVertical = YES;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];

    tableView.tableFooterView = ({
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(tableView.bounds), CGRectGetMinY(tableView.bounds), CGRectGetWidth(tableView.bounds), 300)];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    
    
}

#pragma mark- 取消修改
-(void)cancelChangePassword
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark- 返回多少区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"                   修改超级管理员密码";
    }
    
    return @"                   修改普通管理员密码";
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * sectionZeroView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(tableView.bounds), CGRectGetMinY(tableView.bounds), CGRectGetWidth(tableView.bounds), 60)];
    UIButton * superButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [superButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    superButton.frame = sectionZeroView.bounds;
    [sectionZeroView addSubview:superButton];

    if (section == 0) {
        [superButton setTitle:@"按我确认修改超级管理员密码" forState:UIControlStateNormal];
        //将按钮的是否可点击与2个输入框是否符合条件进行绑定
        RAC(superButton,enabled)=self.superCourrentSignal;
        //条件的扩展，改变颜色
        [self.superCourrentSignal subscribeNext:^(NSNumber *x) {
            if (x.boolValue) {
                [superButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

            }else
            {
                [superButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

            }
        }];
        
        //将按钮的按下时间进行绑定
        @weakify(self);
        [[superButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.superNewPasswordTextField resignFirstResponder];
            [self.superOldPasswordTextField resignFirstResponder];
            NSMutableArray * superPasswords = [[NSMutableArray alloc] initWithArray:[UserDefaults valueForKey:SuperPerson] copyItems:YES];
            NSString *oldPassword = [self.superOldPasswordTextField.text base64EncodedString];
            NSString *newPassword = [self.superNewPasswordTextField.text base64EncodedString];
            [superPasswords replaceObjectAtIndex:[superPasswords indexOfObject:oldPassword] withObject:newPassword];
            [UserDefaults setValue:superPasswords forKey:SuperPerson];
            [UserDefaults synchronize];
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"成功" message:@"超级管理员密码修改成功" delegate:self cancelButtonTitle:@"完成" otherButtonTitles:@"继续修改", nil];
            [alertView show];
            [alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *x) {
                if ([x isEqualToNumber:[NSNumber numberWithInteger:0]]) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }else
                {
                self.superOldPasswordTextField.text = nil;
                self.superNewPasswordTextField.text = nil;
                    if ([superButton isEnabled]) {
                        [superButton setEnabled:NO];
                        [superButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    }
                }
            }];
        }];
        return sectionZeroView;
    }
    
    [superButton setTitle:@"按我确认修改普通管理员密码" forState:UIControlStateNormal];
    RAC(superButton,enabled)=self.normalCourrentSignal;
    [self.normalCourrentSignal subscribeNext:^(NSNumber *x) {
        if (x.boolValue) {
            [superButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
        }else
        {
            [superButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
        }
    }];
    @weakify(self);
    [[superButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.normalOldPasswordTextField resignFirstResponder];
        [self.normalNewPasswordTextField resignFirstResponder];
        NSString *newPassword = [self.normalNewPasswordTextField.text base64EncodedString];
        [UserDefaults setValue:newPassword forKey:NormalPreson];
        [UserDefaults synchronize];
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"成功" message:@"超级管理员密码修改成功" delegate:self cancelButtonTitle:@"完成" otherButtonTitles:@"继续修改", nil];
        [alertView show];
        [alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *x) {
            if ([x isEqualToNumber:[NSNumber numberWithInteger:0]]) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else
            {
                self.normalOldPasswordTextField.text = nil;
                self.normalNewPasswordTextField.text = nil;
                if ([superButton isEnabled]) {
                    [superButton setEnabled:NO];
                    [superButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                }

            }
        }];
    }];
    return sectionZeroView;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndentify = @"cell";
    NSString * key = [NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row];
    UITableViewCell * cell = [self.allCells valueForKey:key];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        [self.allCells setValue:cell forKey:key];
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            self.superOldPasswordTextField = [self creatTextFieldWithView:cell.contentView WithPlaceHolderStr:@"输入老的超级密码(6位以上)" WithTag:71205];
            UIImageView * imageView = [self creatImageViewWithView:self.superOldPasswordTextField];
            self.superOldPasswordTextField.leftView = imageView;
            //信号创建
            self.superOldPasswordSignal = [self.superOldPasswordTextField.rac_textSignal map:^id(NSString * value) {
                NSArray * superPasswords = [UserDefaults valueForKey:SuperPerson];
                NSString * oldPassword = [value base64EncodedString];
                return @([superPasswords containsObject:oldPassword]&&(value.length>=6));
            }];
            //map是改变自己的需求
            RAC(imageView,image) = [self.superOldPasswordSignal map:^id(NSNumber * value) {
                if (value.boolValue) {
                    return Right;
                }
                return Wrong;
            }];
        }else
        {
            self.superNewPasswordTextField = [self creatTextFieldWithView:cell.contentView WithPlaceHolderStr:@"输入新的超级密码(6位以上)" WithTag:71206];
            UIImageView * imageView = [self creatImageViewWithView:self.superNewPasswordTextField];
            self.superNewPasswordTextField.leftView = imageView;
            self.superNewPasswordSignal = [self.superNewPasswordTextField.rac_textSignal map:^id(NSString * value) {
                return @(value.length>=6);
            }];
            RAC(imageView,image) = [self.superNewPasswordSignal map:^id(NSNumber * value) {
                if (value.boolValue) {
                    return Right;
                }
                return Wrong;
            }];
            
            self.superCourrentSignal = [RACSignal combineLatest:@[self.superOldPasswordSignal,self.superNewPasswordSignal] reduce:^(NSNumber*superOldPassword,NSNumber*superNewPassword){
                return @(superOldPassword.boolValue&&superNewPassword.boolValue);
            }];

        }
    }else
    {
        if (indexPath.row==0) {
            self.normalOldPasswordTextField = [self creatTextFieldWithView:cell.contentView WithPlaceHolderStr:@"输入老的普通密码(6位以上)" WithTag:71207];
            UIImageView * imageView = [self creatImageViewWithView:self.normalOldPasswordTextField];
            self.normalOldPasswordTextField.leftView = imageView;
            self.normalOldPasswordSignal = [self.normalOldPasswordTextField.rac_textSignal map:^id(NSString * value) {
                NSString * normalPassword = [UserDefaults valueForKey:NormalPreson];
                NSString * oldPassword = [value base64EncodedString];
                return @([oldPassword isEqualToString:normalPassword]&&(value.length>=6));
            }];
            RAC(imageView,image) = [self.normalOldPasswordSignal map:^id(NSNumber * value) {
                if (value.boolValue) {
                    return Right;
                }
                return Wrong;
            }];

        }else
        {
            self.normalNewPasswordTextField = [self creatTextFieldWithView:cell.contentView WithPlaceHolderStr:@"输入新的普通密码(6位以上)" WithTag:71208];
            UIImageView * imageView = [self creatImageViewWithView:self.normalNewPasswordTextField];
            self.normalNewPasswordTextField.leftView = imageView;
            self.normalNewPasswordSignal = [self.normalNewPasswordTextField.rac_textSignal map:^id(NSString * value) {
                return @(value.length >= 6);
            }];
            RAC(imageView,image) = [self.normalNewPasswordSignal map:^id(NSNumber * value) {
                if (value.boolValue) {
                    return Right;
                }
                return Wrong;
            }];

            self.normalCourrentSignal = [RACSignal combineLatest:@[self.normalOldPasswordSignal,self.normalNewPasswordSignal] reduce:^(NSNumber*normalOldPassword,NSNumber*normalNewPassword){
                return @(normalOldPassword.boolValue&&normalNewPassword.boolValue);
            }];

        }
    }
}

    return cell;
}


#pragma mark- 创建输入框
-(UITextField*)creatTextFieldWithView:(UIView*)view WithPlaceHolderStr:(NSString*)placeHolderStr WithTag:(NSUInteger)textFieldTag
{
    UITextField * field = [[UITextField alloc]initWithFrame:view.bounds];
    field.borderStyle = UITextBorderStyleLine;
    field.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    field.delegate = self;
    field.leftViewMode=UITextFieldViewModeAlways;
    field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.placeholder = placeHolderStr;
    field.tag = textFieldTag;
    field.keyboardType = UIKeyboardTypeNumberPad;
    field.secureTextEntry = YES;
    [view addSubview:field];
    
    return field;

}

#pragma mark- 创建imageview
-(UIImageView*)creatImageViewWithView:(UIView*)view
{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(view.bounds), CGRectGetMinY(view.bounds), CGRectGetHeight(view.bounds), CGRectGetHeight(view.bounds))];
    
    return imageView;

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{

    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
