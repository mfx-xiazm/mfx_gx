//
//  GXMyVC.m
//  GX
//
//  Created by 夏增明 on 2019/9/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMyVC.h"
#import "FSActionSheet.h"
#import "GXMySetVC.h"

@interface GXMyVC ()

@end

@implementation GXMyVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -- 点击事件
/** 客服经理 */
- (IBAction)contactBtnClicked:(UIButton *)sender {
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:@"客户经理" delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"13487655423(王鹏)"]];
    //        hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        //            hx_strongify(weakSelf);
        if (selectedIndex == 1) {
            HXLog(@"拨打");
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"13496755975"]]];
        }
    }];
}
/** 权益中心 */
- (IBAction)memberBtnClicked:(UIButton *)sender {
    
}
/** 设置 */
- (IBAction)settingBtnClicked:(UIButton *)sender {
    GXMySetVC *svc = [GXMySetVC new];
    [self.navigationController pushViewController:svc animated:YES];
}
/** 我的生意 */
- (IBAction)myBusnessBtnClicked:(UIButton *)sender {
    
}
/** 优惠券 */
- (IBAction)myCouponClicked:(UIButton *)sender {
    
}
/** 我的清单 */
- (IBAction)myCollectBtnClicked:(UIButton *)sender {
    
}
- (IBAction)myOrderClicked:(UIButton *)sender {
    
}
- (IBAction)myOtherBtnClicked:(UIButton *)sender {
    
}

@end
