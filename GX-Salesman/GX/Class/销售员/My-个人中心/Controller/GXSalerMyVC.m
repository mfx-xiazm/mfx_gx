//
//  GXSalerMyVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXSalerMyVC.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "GXLoginVC.h"
#import "HXNavigationController.h"
#import "GXShareCodeVC.h"
#import "GXCashVC.h"
#import "GXBalanceNoteVC.h"
#import "GXClientManageVC.h"
#import "GXMyTeamVC.h"
#import "GXPartnerIncomeVC.h"

@interface GXSalerMyVC ()
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *cash_balance;
/* 账户信息 */
@property(nonatomic,strong) NSDictionary *accountData;
/* 提现天数 */
@property(nonatomic,copy) NSString *cashable_day;
@property (nonatomic, copy) NSString *shareCode;
@property (nonatomic, copy) NSString *register_url;
@end

@implementation GXSalerMyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavbar];
    [self getMemberRequest];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserBalanceRequest];
}
-(void)setUpNavbar
{
    self.hbd_barAlpha = 0.0;
    
    [self.navigationItem setTitle:@"个人中心"];
    
    SPButton *set = [SPButton buttonWithType:UIButtonTypeCustom];
    set.hxn_size = CGSizeMake(40, 40);
    set.titleLabel.font = [UIFont systemFontOfSize:9];
    [set setImage:HXGetImage(@"退出") forState:UIControlStateNormal];
    [set addTarget:self action:@selector(logOutClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:set];
}
#pragma mark -- 点击事件
- (void)logOutClicked:(UIButton *)sender {
    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要退出登录？" constantWidth:HX_SCREEN_WIDTH - 50*2];
    hx_weakify(self);
    zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
    }];
    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"退出" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
        
        [[MSUserManager sharedInstance] logout:nil];
        
        GXLoginVC *lvc = [GXLoginVC new];
        HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:lvc];
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        
        //推出主界面出来
        CATransition *ca = [CATransition animation];
        ca.type = @"movein";
        ca.duration = 0.5;
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
    }];
    cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    okButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
    [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
    self.zh_popupController = [[zhPopupController alloc] init];
    [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
}
- (IBAction)codeClicked:(UIButton *)sender {
    GXShareCodeVC *cvc = [GXShareCodeVC new];
    cvc.shareCode = self.shareCode;
    cvc.register_url = self.register_url;
    [self.navigationController pushViewController:cvc animated:YES];
}
- (IBAction)balanceNoteClicked:(UIButton *)sender {
    GXBalanceNoteVC *nvc = [GXBalanceNoteVC new];
    [self.navigationController pushViewController:nvc animated:YES];
}
- (IBAction)cashNoteClicked:(UIButton *)sender {
    GXCashVC *cvc = [GXCashVC new];
    cvc.cashable = [NSString stringWithFormat:@"%@",self.accountData[@"cashable_balance"]];
    [self.navigationController pushViewController:cvc animated:YES];
}
- (IBAction)cashNoticeClicked:(UIButton *)sender {
    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提现说明" message:[NSString stringWithFormat:@"订单确认收货后，%@天后才能申请提现",self.cashable_day] constantWidth:HX_SCREEN_WIDTH - 50*2];
    hx_weakify(self);
    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"我知道了" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
    }];
    okButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
    [alert addAction:okButton];
    self.zh_popupController = [[zhPopupController alloc] init];
    [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
}
- (IBAction)clientManageClicked:(UIButton *)sender {
    GXClientManageVC *mvc = [GXClientManageVC new];
    [self.navigationController pushViewController:mvc animated:YES];
}
- (IBAction)partnerIncomeClicked:(UIButton *)sender {
    GXPartnerIncomeVC *pvc = [GXPartnerIncomeVC new];
    [self.navigationController pushViewController:pvc animated:YES];
}

- (IBAction)myTeamClicked:(UIButton *)sender {
    GXMyTeamVC *tvc = [GXMyTeamVC new];
    [self.navigationController pushViewController:tvc animated:YES];
}

#pragma mark -- 接口
-(void)getMemberRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"program/getMineData" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf showInviteData:responseObject[@"data"]];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getUserBalanceRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:[[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"2"]?@"index/getUserBalance":@"program/getUserBalance" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.accountData = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
            if ([[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"2"]) {
                strongSelf.cashable_day = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"provider_cashable_day"]];
            }else{
                strongSelf.cashable_day = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"saleman_cashable_day"]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.balance.text = [NSString stringWithFormat:@"%@元",responseObject[@"data"][@"balance"]];
                strongSelf.cash_balance.text = [NSString stringWithFormat:@"%@元",responseObject[@"data"][@"cashable_balance"]];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)showInviteData:(NSDictionary *)result
{
    self.userName.text = [NSString stringWithFormat:@"%@",result[@"username"]];
    self.phone.text = [NSString stringWithFormat:@"%@",result[@"phone"]];
    
    self.shareCode = [NSString stringWithFormat:@"%@",result[@"share_code"]];
    self.register_url = [NSString stringWithFormat:@"%@",result[@"register_url"]];
}
@end
