//
//  GXShareCodeVC.m
//  GX
//
//  Created by huaxin-01 on 2020/6/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXShareCodeVC.h"
#import "SGQRCode.h"
#import "GXSaveImageToPHAsset.h"
#import "zhAlertView.h"
#import <zhPopupController.h>

@interface GXShareCodeVC ()
@property (weak, nonatomic) IBOutlet UIView *shareCodeView;
@property (weak, nonatomic) IBOutlet UIImageView *shareCodeImg;
@property (weak, nonatomic) IBOutlet UILabel *shareCodeLabel;
@property (nonatomic, strong) zhPopupController *sharePopVC;
@end

@implementation GXShareCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hbd_barAlpha = 0.0;
    [self.navigationItem setTitle:@"邀请码"];
    self.shareCodeImg.image = [SGQRCodeObtain generateQRCodeWithData:self.register_url size:self.shareCodeImg.hxn_width];
    self.shareCodeLabel.text = [NSString stringWithFormat:@"我的邀请码：%@",self.shareCode];
}
- (IBAction)saveBtnClicked:(UIButton *)sender {
    GXSaveImageToPHAsset *savePh = [[GXSaveImageToPHAsset alloc] init];
    savePh.targetVC = self;
    hx_weakify(self);
    [savePh saveImages:@[[self.shareCodeView imageWithUIView]] comletedCall:^(NSInteger result) {
        hx_strongify(weakSelf);
        // 复制文本
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            if (result != 0) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"保存成功"];
            }else{
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相册权限" message:@"设置-隐私-相册" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                    [strongSelf.sharePopVC dismiss];
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];//跳转到本应用的设置页面
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert addAction:okButton];
                strongSelf.sharePopVC = [[zhPopupController alloc] initWithView:alert size:alert.bounds.size];
                [strongSelf.sharePopVC show];
            }
        });
    }];
}

@end
