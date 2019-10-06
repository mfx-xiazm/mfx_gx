//
//  GXMySetVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMySetVC.h"
#import "GXChangePwdVC.h"
#import "GXChangeBindVC.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "GXMyLicenceVC.h"
#import "GXWebContentVC.h"

@interface GXMySetVC ()

@end

@implementation GXMySetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"设置"];
}
- (IBAction)setBtnClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        GXChangeBindVC *bvc = [GXChangeBindVC new];
        [self.navigationController pushViewController:bvc animated:YES];
    }else if (sender.tag == 2) {
        GXChangePwdVC *pvc = [GXChangePwdVC new];
        [self.navigationController pushViewController:pvc animated:YES];
    }else if (sender.tag == 3) {
        GXMyLicenceVC *lvc = [GXMyLicenceVC new];
        [self.navigationController pushViewController:lvc animated:YES];
    }else if (sender.tag == 4) {
        GXMyLicenceVC *lvc = [GXMyLicenceVC new];
        [self.navigationController pushViewController:lvc animated:YES];
    }else if (sender.tag == 5) {
        GXWebContentVC *wvc = [GXWebContentVC new];
        wvc.url = @"http://news.cctv.com/2019/10/03/ARTI2EUlwRGH3jMPI6cAVqti191003.shtml";
        wvc.navTitle = @"关于呱选";
        [self.navigationController pushViewController:wvc animated:YES];
    }else if (sender.tag == 6) {
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要清除缓存？" constantWidth:HX_SCREEN_WIDTH - 50*2];
        hx_weakify(self);
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
        }];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"清除" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"13496755975"]]];
        }];
        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
        [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
        self.zh_popupController = [[zhPopupController alloc] init];
        [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
    }else{
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要退出登录？" constantWidth:HX_SCREEN_WIDTH - 50*2];
        hx_weakify(self);
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
        }];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"退出" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"13496755975"]]];
        }];
        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
        self.zh_popupController = [[zhPopupController alloc] init];
        [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
    }
}

@end
