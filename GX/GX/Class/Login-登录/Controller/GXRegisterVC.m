//
//  GXRegisterVC.m
//  GX
//
//  Created by 夏增明 on 2019/9/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXRegisterVC.h"
#import "GXRegisterAuthVC.h"
#import "FSActionSheet.h"
#import "GXRegisterAuthVC2.h"

@interface GXRegisterVC ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *role;
/* 注册类型 */
@property(nonatomic,copy) NSString *role_type;
/* 验证码id */
@property(nonatomic,copy) NSString *sms_id;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@end

@implementation GXRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"注册"];
    
    hx_weakify(self);
    [self.nextBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.name hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入姓名"];
            return NO;
        }
        if (![strongSelf.phone hasText] || strongSelf.phone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机格式有误"];
            return NO;
        }
        if (![strongSelf.pwd hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入密码"];
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
        if (![strongSelf.role hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择角色"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf nextBtnClicked:button];
    }];
}
- (IBAction)chooseRoleClicked:(UIButton *)sender {
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:@"注册类型" delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"终端店",@"供销商"]];
    hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        hx_strongify(weakSelf);
        if (selectedIndex == 0) {
            strongSelf.role.text = @"终端店";
            strongSelf.role_type = @"1";
        }else {
            strongSelf.role.text = @"供销商";
            strongSelf.role_type = @"2";
        }
    }];
}

- (IBAction)pwdStatusClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.pwd.secureTextEntry = !sender.isSelected;
}
- (IBAction)getCodeRequest:(UIButton *)sender {
    if (![self.phone hasText] || self.phone.text.length != 11) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机格式有误"];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"phone"] = self.phone.text;
    parameters[@"type"] = @"1";//默认为1 为1表示注册时获取短信验证码或者更换手机号时获取验证码 为2表示忘记密码重置密码或更新密码时获取验证码
    
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
- (IBAction)goLoginClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)nextBtnClicked:(UIButton *)sender {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"sms_id"] = self.sms_id;//短信验证码id
    parameters[@"sms_code"] = self.code.text;//短信验证码
    parameters[@"phone"] = self.phone.text;//手机号
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/checkCode" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [sender stopLoading:@"下一步" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([strongSelf.role_type isEqualToString:@"1"]) {// 终端店
                    GXRegisterAuthVC *svc = [GXRegisterAuthVC new];
                    svc.phone = strongSelf.phone.text;
                    svc.pwd = strongSelf.pwd.text;
                    svc.username = strongSelf.name.text;
                    [strongSelf.navigationController pushViewController:svc animated:YES];
                }else{// 供销商
                    GXRegisterAuthVC2 *avc = [GXRegisterAuthVC2 new];
                    avc.phone = strongSelf.phone.text;
                    avc.pwd = strongSelf.pwd.text;
                    avc.username = strongSelf.name.text;
                    [strongSelf.navigationController pushViewController:avc animated:YES];
                }
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [sender stopLoading:@"下一步" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}

@end
