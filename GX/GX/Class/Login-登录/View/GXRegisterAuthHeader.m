//
//  GXRegisterAuthHeader.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXRegisterAuthHeader.h"
#import "GXRunCategoryView.h"
#import <zhPopupController.h>
#import "GXChooseAddressView.h"

@interface GXRegisterAuthHeader ()
/* 地址 */
@property(nonatomic,strong) GXChooseAddressView *addressView;
@end
@implementation GXRegisterAuthHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(GXChooseAddressView *)addressView
{
    if (_addressView == nil) {
        _addressView = [GXChooseAddressView loadXibView];
        _addressView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 360);
        __weak __typeof(self) weakSelf = self;
        // 最后一列的行被点击的回调
        _addressView.lastComponentClickedBlock = ^(SPProvince *selectedProvince, SPCity *selectedCity, SPDistrict *selectedDistrict) {
            
            [weakSelf.target.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        HXLog(@"选中的%@-%@-%@",selectedProvince.fullname,selectedCity.fullname,selectedDistrict.fullname);
        };
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pcd.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        // 给addressView传数据
        _addressView.datas = dictArray;
    }
    return _addressView;
}
- (IBAction)chooseCateClicked:(UIButton *)sender {
    GXRunCategoryView *hvc = [GXRunCategoryView loadXibView];
    hvc.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-30*2, 260);
    
    self.target.zh_popupController = [[zhPopupController alloc] init];
    self.target.zh_popupController.layoutType = zhPopupLayoutTypeCenter;
    [self.target.zh_popupController presentContentView:hvc duration:0.25 springAnimated:NO];
}

- (IBAction)chooseAdressClicked:(UIButton *)sender {
    self.target.zh_popupController = [[zhPopupController alloc] init];
    self.target.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.target.zh_popupController presentContentView:self.addressView duration:0.25 springAnimated:NO];
}

@end
