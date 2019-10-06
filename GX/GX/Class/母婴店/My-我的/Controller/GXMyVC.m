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
#import "GXWebContentVC.h"
#import "GXMyCollectVC.h"
#import "GXMyBusinessVC.h"
#import "GXMyCouponVC.h"
#import "GXInviteVC.h"
#import "GXComplainVC.h"
#import "GXMyAddressVC.h"
#import "GXHelpVC.h"
#import "GXReportVC.h"
#import "GXMemberVC.h"
#import "GXMyIdeaVC.h"
#import "GXMyOrderVC.h"

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
    GXMemberVC *mvc = [GXMemberVC new];
    [self.navigationController pushViewController:mvc animated:YES];
}
/** 设置 */
- (IBAction)settingBtnClicked:(UIButton *)sender {
    GXMySetVC *svc = [GXMySetVC new];
    [self.navigationController pushViewController:svc animated:YES];
}
/** 我的生意 */
- (IBAction)myBusnessBtnClicked:(UIButton *)sender {
    GXMyBusinessVC *bvc = [GXMyBusinessVC new];
    [self.navigationController pushViewController:bvc animated:YES];
}
/** 优惠券 */
- (IBAction)myCouponClicked:(UIButton *)sender {
    GXMyCouponVC *cvc = [GXMyCouponVC new];
    [self.navigationController pushViewController:cvc animated:YES];
}
/** 我的清单 */
- (IBAction)myCollectBtnClicked:(UIButton *)sender {
    GXMyCollectVC *cvc = [GXMyCollectVC new];
    [self.navigationController pushViewController:cvc animated:YES];
}
/** 我的订单 */
- (IBAction)myOrderClicked:(UIButton *)sender {
    GXMyOrderVC *ovc = [GXMyOrderVC new];
    ovc.selectIndex = sender.tag;
    [self.navigationController pushViewController:ovc animated:YES];
}
/** 其他操作 */
- (IBAction)myOtherBtnClicked:(UIButton *)sender {
    if (sender.tag == 0) {
        GXInviteVC *ivc = [GXInviteVC new];
        [self.navigationController pushViewController:ivc animated:YES];
    }else if (sender.tag == 1){
        GXMyAddressVC *avc = [GXMyAddressVC new];
        [self.navigationController pushViewController:avc animated:YES];
    }else if (sender.tag == 2){
        GXWebContentVC *wvc = [GXWebContentVC new];
        wvc.url = @"http://news.cctv.com/2019/10/03/ARTI2EUlwRGH3jMPI6cAVqti191003.shtml";
        wvc.navTitle = @"售后标准";
        [self.navigationController pushViewController:wvc animated:YES];
    }else if (sender.tag == 3){
        GXMemberVC *mvc = [GXMemberVC new];
        [self.navigationController pushViewController:mvc animated:YES];
    }else if (sender.tag == 4){
        GXHelpVC *hvc = [GXHelpVC new];
        [self.navigationController pushViewController:hvc animated:YES];
    }else if (sender.tag == 5){
        GXMyIdeaVC *cvc = [GXMyIdeaVC new];
        [self.navigationController pushViewController:cvc animated:YES];
    }else if (sender.tag == 6){
        GXComplainVC *cvc = [GXComplainVC new];
        [self.navigationController pushViewController:cvc animated:YES];
    }else if (sender.tag == 7){
        GXReportVC *rvc = [GXReportVC new];
        [self.navigationController pushViewController:rvc animated:YES];
    }else if (sender.tag == 8){
        FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:@"客户经理" delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"13487655423(王鹏)"]];
        //        hx_weakify(self);
        [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
            //            hx_strongify(weakSelf);
            if (selectedIndex == 1) {
                HXLog(@"拨打");
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"13496755975"]]];
            }
        }];
    }else{
        GXWebContentVC *wvc = [GXWebContentVC new];
        wvc.url = @"http://news.cctv.com/2019/10/03/ARTI2EUlwRGH3jMPI6cAVqti191003.shtml";
        wvc.navTitle = @"申请供货";
        [self.navigationController pushViewController:wvc animated:YES];
    }
}

@end
