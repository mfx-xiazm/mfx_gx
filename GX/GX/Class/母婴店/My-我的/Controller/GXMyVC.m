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
    
}
/** 其他操作 */
- (IBAction)myOtherBtnClicked:(UIButton *)sender {
    if (sender.tag == 0) {
        
    }else if (sender.tag == 0){
        
    }else if (sender.tag == 0){
        
    }else if (sender.tag == 0){
        
    }else if (sender.tag == 0){
        
    }else if (sender.tag == 0){
        
    }else if (sender.tag == 0){
        
    }else if (sender.tag == 0){
        
    }else if (sender.tag == 0){
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
