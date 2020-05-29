//
//  GXSalerMyVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXSalerMyVC.h"
#import "SGQRCode.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "GXLoginVC.h"
#import "HXNavigationController.h"

@interface GXSalerMyVC ()
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UIImageView *shareCodeImg;
@property (weak, nonatomic) IBOutlet UILabel *shareCode;

@end

@implementation GXSalerMyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMemberRequest];
}
- (IBAction)logOutClicked:(UIButton *)sender {
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
-(void)showInviteData:(NSDictionary *)result
{
    self.userName.text = [NSString stringWithFormat:@"%@",result[@"username"]];
    self.phone.text = [NSString stringWithFormat:@"%@",result[@"phone"]];
    self.shareCodeImg.image = [SGQRCodeObtain generateQRCodeWithData:result[@"register_url"] size:self.shareCodeImg.hxn_width];
    self.shareCode.text = [NSString stringWithFormat:@"我的邀请码：%@",result[@"share_code"]];
}
@end
