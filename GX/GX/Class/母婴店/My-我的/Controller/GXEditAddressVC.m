//
//  GXEditAddressVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXEditAddressVC.h"
#import "GXChooseAddressView.h"
#import <zhPopupController.h>
#import "HXPlaceholderTextView.h"

@interface GXEditAddressVC ()
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *addressDetial;
/* 地址 */
@property(nonatomic,strong) GXChooseAddressView *addressView;
@end

@implementation GXEditAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"新增收货地址"];
    self.addressDetial.placeholder = @"请输入详细的收货地址";
}
-(GXChooseAddressView *)addressView
{
    if (_addressView == nil) {
        _addressView = [GXChooseAddressView loadXibView];
        _addressView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 360);
        __weak __typeof(self) weakSelf = self;
        // 最后一列的行被点击的回调
        _addressView.lastComponentClickedBlock = ^(SPProvince *selectedProvince, SPCity *selectedCity, SPDistrict *selectedDistrict) {
            
            [weakSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        HXLog(@"选中的%@-%@-%@",selectedProvince.fullname,selectedCity.fullname,selectedDistrict.fullname);
        };
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pcd.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        // 给addressView传数据
        _addressView.datas = dictArray;
    }
    return _addressView;
}
- (IBAction)regionClicked:(UIButton *)sender {
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:self.addressView duration:0.25 springAnimated:NO];
}

@end
