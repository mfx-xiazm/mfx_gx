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
#import "HXCacheTool.h"
#import "GXMineData.h"
#import "GXLoginVC.h"
#import "HXNavigationController.h"

#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

@interface GXMySetVC ()
@property (weak, nonatomic) IBOutlet UILabel *accunt;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *current_version;
@property (weak, nonatomic) IBOutlet UILabel *cache;

@end

@implementation GXMySetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"设置"];
    
    self.accunt.text = self.mineData.phone;
    self.phone.text = self.mineData.phone;
    NSString *key = @"CFBundleShortVersionString";
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    self.current_version.text = currentVersion;
    
    hx_weakify(self);
    [HXCacheTool getFileSize:CachePath completion:^(NSInteger size) {
        hx_strongify(weakSelf);
        strongSelf.cache.text = [strongSelf sizeStr:size];
    }];
}
// 获取缓存尺寸字符串
- (NSString *)sizeStr:(NSInteger)size
{
    NSInteger totalSize = size;
    NSString *sizeStr;
    // MB KB B
    if (totalSize > 1024 * 1024) {
        // MB
        CGFloat sizeF = totalSize / 1024.0 / 1024.0;
        sizeStr = [NSString stringWithFormat:@"%.1fMB",sizeF];
    } else if (totalSize > 1024) {
        // KB
        CGFloat sizeF = totalSize / 1024.0;
        sizeStr = [NSString stringWithFormat:@"%.1fKB",sizeF];
    } else if (totalSize > 0) {
        // B
        sizeStr = [NSString stringWithFormat:@"%.ldB",totalSize];
    }
    
    return sizeStr;
}
- (IBAction)setBtnClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        GXChangeBindVC *bvc = [GXChangeBindVC new];
        bvc.phoneStr = self.mineData.phone;
        hx_weakify(self);
        bvc.changeSuccessCall = ^(NSString * _Nonnull phone) {
            hx_strongify(weakSelf);
            strongSelf.accunt.text = phone;
            strongSelf.phone.text = phone;
            strongSelf.mineData.phone = phone;
        };
        [self.navigationController pushViewController:bvc animated:YES];
    }else if (sender.tag == 2) {
        GXChangePwdVC *pvc = [GXChangePwdVC new];
        pvc.dataType = 2;
        [self.navigationController pushViewController:pvc animated:YES];
    }else if (sender.tag == 3) {
        GXMyLicenceVC *lvc = [GXMyLicenceVC new];
        lvc.seaType = @"1";
        [self.navigationController pushViewController:lvc animated:YES];
    }else if (sender.tag == 4) {
        GXMyLicenceVC *lvc = [GXMyLicenceVC new];
        lvc.seaType = @"2";
        [self.navigationController pushViewController:lvc animated:YES];
    }else if (sender.tag == 5) {
        GXWebContentVC *wvc = [GXWebContentVC new];
        wvc.navTitle = @"关于呱选";
        wvc.isNeedRequest = YES;
        wvc.requestType = 4;
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
            // 删除文件夹里面所有文件
            [HXCacheTool removeDirectoryPath:CachePath];
            strongSelf.cache.text = @"0.0K";
            [MBProgressHUD showTitleToView:strongSelf.view postion:NHHUDPostionTop title:@"清除成功"];
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
}

@end
