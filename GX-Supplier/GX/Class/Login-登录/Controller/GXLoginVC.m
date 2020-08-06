//
//  GXLoginVC.m
//  GX
//
//  Created by 夏增明 on 2019/9/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXLoginVC.h"
#import "HXTabBarController.h"
#import "GXChangePwdVC.h"
#import "GXRegisterVC.h"
#import "UITextField+GYExpand.h"
#import "GXAboutUsVC.h"
#import "GXAuthStep1VC.h"
#import "GXAuthStep2VC.h"
#import "GXAuthStep3VC.h"
#import "GXAuthStep4VC.h"
#import "UICKeyChainStore.h"
#import "GXEnterPlatVC.h"
#import "GXUnionAuthVC.h"
#import "GXWebContentVC.h"
#import "zhAlertView.h"
#import <zhPopupController.h>

@interface GXLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation GXLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"登录"];
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"guaxuangys.mfxapp.com"];
    NSString *phone = [keychain stringForKey:@"phone"];
    NSString *password = [keychain stringForKey:@"pwd"];
    if (phone && phone.length) {
        self.phone.text = phone;
    }
    if (password && password.length) {
        self.pwd.text = password;
    }
    
    hx_weakify(self);
    [self.phone lengthLimit:^{
        hx_strongify(weakSelf);
        if (strongSelf.phone.text.length > 11) {
            strongSelf.phone.text = [strongSelf.phone.text substringToIndex:11];
        }
    }];
    
    [self.loginBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.phone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入登录手机号"];
            return NO;
        }
        if (strongSelf.phone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机号格式有误"];
            return NO;
        }
        if (![strongSelf.pwd hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入密码"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf loginClicked:button];
    }];
}
- (void)loginClicked:(UIButton *)sender {

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"username"] = self.phone.text;
    parameters[@"password"] = self.pwd.text;
    /** 1 母婴店 2供应商 3销售员 */
    parameters[@"utype"] = @"2";

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"index/userLogin" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [sender stopLoading:@"登录" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"guaxuangys.mfxapp.com"];
            [keychain setString:strongSelf.phone.text forKey:@"phone"];
            [keychain setString:strongSelf.pwd.text forKey:@"pwd"];

            if ([responseObject[@"data"][@"is_register"] integerValue] == 0) {
                if ([responseObject[@"data"][@"step"] integerValue] == 1) {
                    GXAuthStep1VC *svc = [GXAuthStep1VC new];
                    svc.uid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"uid"]];
                    svc.token = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"token"]];
                    [strongSelf.navigationController pushViewController:svc animated:YES];
                }else if ([responseObject[@"data"][@"step"] integerValue] == 2) {
                    if ([responseObject[@"data"][@"approve_status"] integerValue] == 2) {

                    }else{
                        GXAuthStep1VC *svc = [GXAuthStep1VC new];
                        svc.uid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"uid"]];
                        svc.token = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"token"]];
                        svc.approve_status = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"approve_status"]];
                        svc.reject_reason = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"reject_reason"]];
                        [strongSelf.navigationController pushViewController:svc animated:YES];
                    }
                }else if ([responseObject[@"data"][@"step"] integerValue] == 3) {
                    GXAuthStep2VC *svc = [GXAuthStep2VC new];
                    svc.uid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"uid"]];
                    svc.token = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"token"]];
                    [strongSelf.navigationController pushViewController:svc animated:YES];
                }else{
                    GXAuthStep4VC *svc = [GXAuthStep4VC new];
                    svc.uid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"uid"]];
                    svc.token = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"token"]];
                    [strongSelf.navigationController pushViewController:svc animated:YES];
                }
            }else{
                // 0.待签约 1.对公账号核对 2.审核中  3.审核成功'
                if ([responseObject[@"data"][@"sign_status"] isKindOfClass:[NSNull class]] || [responseObject[@"data"][@"sign_status"] integerValue] == 0) {
                    GXEnterPlatVC *pvc = [GXEnterPlatVC new];
                    pvc.uid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"uid"]];
                    pvc.token = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"token"]];
                    [strongSelf.navigationController pushViewController:pvc animated:YES];
                }else if ([responseObject[@"data"][@"sign_status"] integerValue] == 1) {
                    GXUnionAuthVC *uvc = [GXUnionAuthVC new];
                    uvc.uid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"uid"]];
                    uvc.token = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"token"]];
                    uvc.company_account = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"company_account"]];
                    uvc.ums_reg_id = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"ums_reg_id"]];
                    [strongSelf.navigationController pushViewController:uvc animated:YES];
                }else if ([responseObject[@"data"][@"sign_status"] integerValue] == 2) {
                    [strongSelf getSignStatusDataRequest:@"7" ums_reg_id:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"ums_reg_id"]] responseObject:responseObject];
                }else{
                    MSUserInfo *info = [MSUserInfo yy_modelWithDictionary:responseObject[@"data"]];
                    [MSUserManager sharedInstance].curUserInfo = info;
                    [[MSUserManager sharedInstance] saveUserInfo];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        HXTabBarController *tab = [[HXTabBarController alloc] init];
                        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
                        
                        //推出主界面出来
                        CATransition *ca = [CATransition animation];
                        ca.type = @"movein";
                        ca.duration = 0.5;
                        [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
                    });
                }
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [sender stopLoading:@"登录" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getSignStatusDataRequest:(NSString *)seaType ums_reg_id:(NSString *)ums_reg_id responseObject:(id)loginObject
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"seaType"] = seaType;
    parameters[@"ums_reg_id"] = ums_reg_id;
    parameters[@"uid"] = loginObject[@"data"][@"uid"];
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"index/applyQry" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            NSDictionary *resultDict = [responseObject[@"data"] dictionaryWithJsonString];
            /**
             00：签约中
             01：签约成功（中间状态）
             02：入网审核中（人工审核流程）
             03：入网成功（最终成功状态）
             04：入网失败
             05：对公账户待验证或异常（对公账户状态）
             06：风控审核中（系统审核状态）
             11：短信签生成合同成功（短信签约流程）
             18：资料填写中（前端流程状态）
             28：资料验证失败
             31：冻结账户
             99：其它错误
             */
            if ([resultDict[@"apply_status"] isEqualToString:@"00"]) {
                [strongSelf getSignWebDataRequest:@"6" ums_reg_id:ums_reg_id];
            }else if ([resultDict[@"apply_status"] isEqualToString:@"03"]) {
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:[resultDict objectForKey:@"apply_status_msg"] constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"进入主页" handler:^(zhAlertButton * _Nonnull button) {
                    [strongSelf.zh_popupController dismiss];
                    MSUserInfo *info = [MSUserInfo yy_modelWithDictionary:loginObject[@"data"]];
                    [MSUserManager sharedInstance].curUserInfo = info;
                    [[MSUserManager sharedInstance] saveUserInfo];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        HXTabBarController *tab = [[HXTabBarController alloc] init];
                        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
                        
                        //推出主界面出来
                        CATransition *ca = [CATransition animation];
                        ca.type = @"movein";
                        ca.duration = 0.5;
                        [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
                    });
                }];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert addAction:okButton];
                strongSelf.zh_popupController = [[zhPopupController alloc] init];
                strongSelf.zh_popupController.dismissOnMaskTouched = NO;
                [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }else{
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@原因：\n%@",[resultDict objectForKey:@"apply_status_msg"],[resultDict objectForKey:@"fail_reason"]] constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                    [strongSelf.zh_popupController dismiss];
                }];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"修改资料" handler:^(zhAlertButton * _Nonnull button) {
                    [strongSelf.zh_popupController dismiss];
                    GXEnterPlatVC *pvc = [GXEnterPlatVC new];
                    pvc.uid = [NSString stringWithFormat:@"%@",loginObject[@"data"][@"uid"]];
                    pvc.token = [NSString stringWithFormat:@"%@",loginObject[@"data"][@"token"]];
                    [strongSelf.navigationController pushViewController:pvc animated:YES];
                }];
                cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [cancelButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
                strongSelf.zh_popupController = [[zhPopupController alloc] init];
                strongSelf.zh_popupController.dismissOnMaskTouched = NO;
                [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getSignWebDataRequest:(NSString *)seaType ums_reg_id:(NSString *)ums_reg_id
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"seaType"] = seaType;
    parameters[@"ums_reg_id"] = ums_reg_id;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"index/signData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            GXWebContentVC *wvc = [GXWebContentVC new];
            wvc.isNeedRequest = NO;
            wvc.url = responseObject[@"data"];
            [strongSelf.navigationController pushViewController:wvc animated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
- (IBAction)pwdStatusClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.pwd.secureTextEntry = !sender.isSelected;
}
- (IBAction)forgetClicked:(UIButton *)sender {
    GXChangePwdVC *pvc = [GXChangePwdVC new];
    pvc.dataType = 1;
    [self.navigationController pushViewController:pvc animated:YES];
}
- (IBAction)registerClicked:(UIButton *)sender {
    GXAboutUsVC *avc = [GXAboutUsVC new];
    [self.navigationController pushViewController:avc animated:YES];
}

@end
