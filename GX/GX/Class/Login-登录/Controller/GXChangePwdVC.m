//
//  GXChangePwdVC.m
//  GX
//
//  Created by 夏增明 on 2019/9/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXChangePwdVC.h"
#import "UICKeyChainStore.h"

@interface GXChangePwdVC ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwd;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
/* 验证码id */
@property(nonatomic,copy) NSString *sms_id;
@end

@implementation GXChangePwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:(self.dataType==1)?@"忘记密码":@"修改密码"];
    
    if (self.phoneStr) {
        self.phone.text = self.phoneStr;
    }
    
    hx_weakify(self);
    [self.sureBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.phone hasText] || strongSelf.phone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机格式有误"];
            return NO;
        }
        if (!strongSelf.sms_id || !strongSelf.sms_id.length) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请获取验证码"];
            return NO;
        }
        if (![strongSelf.code hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入验证码"];
            return NO;
        }
        if (![strongSelf.pwd hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入密码"];
            return NO;
        }
        if (![strongSelf.confirmPwd hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入确认密码"];
            return NO;
        }
        if (![strongSelf.pwd.text isEqualToString:strongSelf.confirmPwd.text]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"确认密码有误"];
            return NO;
        }
        
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf forgetPasswordRequest:button];
    }];
}
- (IBAction)getCodeRequest:(UIButton *)sender {
    if (![self.phone hasText] || self.phone.text.length != 11) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机格式有误"];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"phone"] = self.phone.text;
    parameters[@"type"] = @"2";//默认为1 表示注册时获取短信验证码 为2表示修改手机号或密码或忘记密码时获取验证码
    /** 1 母婴店 2供应商 3销售员 */
    parameters[@"utype"] = @"1";
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getCheckCode" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [sender startWithTime:59 title:@"获取验证码" countDownTitle:@"s" mainColor:HXControlBg countColor:HXControlBg];
            strongSelf.sms_id = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)forgetPasswordRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"phone"] = self.phone.text;
    parameters[@"sms_id"] = self.sms_id;
    parameters[@"sms_code"] = self.code.text;
    parameters[@"password"] = self.pwd.text;
    parameters[@"confirmPass"] = self.confirmPwd.text;
    /** 1 母婴店 2供应商 3销售员 */
    parameters[@"utype"] = @"1";
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:(self.dataType ==1)?@"admin/forgetPassword":@"admin/editPassword" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"guaxuan.mfxapp.com"];
            [keychain setString:strongSelf.confirmPwd.text forKey:@"pwd"];
            
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
