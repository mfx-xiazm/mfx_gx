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
#import "UITextField+GYExpand.h"
#import "UICKeyChainStore.h"
#import "GXRegisterVC.h"

@interface GXLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@end

@implementation GXLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"登录"];
    
    NSInteger isRegister = [[NSUserDefaults standardUserDefaults] integerForKey:@"isRegister"];
    if (isRegister) {
        self.registerBtn.hidden = NO;
    }else{
        self.registerBtn.hidden = YES;
    }
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"guaxuanxsy.mfxapp.com"];
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getIsRegisterRequest];
}
-(void)getIsRegisterRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"program/isRegister" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [[NSUserDefaults standardUserDefaults] setInteger:[responseObject[@"data"] integerValue] forKey:@"isRegister"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if ([responseObject[@"data"] integerValue] == 1) {
                strongSelf.registerBtn.hidden = NO;
            }else{
                strongSelf.registerBtn.hidden = YES;
            }
        }
    } failure:^(NSError *error) {

    }];
}
- (void)loginClicked:(UIButton *)sender {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"username"] = self.phone.text;
    parameters[@"password"] = self.pwd.text;
    /** 1 母婴店 2供应商 3销售员 */
    parameters[@"utype"] = @"3";
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"program/userLogin" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [sender stopLoading:@"登录" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"guaxuanxsy.mfxapp.com"];
            [keychain setString:strongSelf.phone.text forKey:@"phone"];
            [keychain setString:strongSelf.pwd.text forKey:@"pwd"];
            
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
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [sender stopLoading:@"登录" image:nil textColor:nil backgroundColor:nil];
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
    GXRegisterVC *avc = [GXRegisterVC new];
    [self.navigationController pushViewController:avc animated:YES];
}
@end
