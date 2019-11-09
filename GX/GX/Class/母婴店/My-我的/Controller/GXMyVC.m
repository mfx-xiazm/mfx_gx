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
#import "GXMineData.h"

@interface GXMyVC ()
/* 个人信息 */
@property(nonatomic,strong) GXMineData *mineData;
@property (weak, nonatomic) IBOutlet UIImageView *shop_img;
@property (weak, nonatomic) IBOutlet UILabel *shop_name;
@property (weak, nonatomic) IBOutlet UIButton *user_level;
@property (weak, nonatomic) IBOutlet UIButton *sale_man;

@end

@implementation GXMyVC

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMemberRequest];
}
#pragma mark -- 业务逻辑
-(void)getMemberRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getMineData" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.mineData = [GXMineData yy_modelWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleMineData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)handleMineData
{
    [self.shop_img sd_setImageWithURL:[NSURL URLWithString:self.mineData.shop_front_img]];
    self.shop_name.text = self.mineData.shop_name;
    if (self.mineData.level_id && self.mineData.level_id.length) {
        self.user_level.hidden = NO;
        [self.user_level setTitle:self.mineData.level_name forState:UIControlStateNormal];
    }else{
        self.user_level.hidden = YES;
    }
    
    if (self.mineData.saleman_phone && self.mineData.saleman_phone.length) {
        self.sale_man.hidden = NO;
    }else{
        self.sale_man.hidden = YES;
    }
}
#pragma mark -- 点击事件
/** 客服经理 */
- (IBAction)contactBtnClicked:(UIButton *)sender {
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:@"客户经理" delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[[NSString stringWithFormat:@"%@(%@)",self.mineData.saleman_phone,self.mineData.saleman_name]]];
    hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        hx_strongify(weakSelf);
        if (selectedIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",strongSelf.mineData.saleman_phone]]];
        }
    }];
}
/** 权益中心 */
- (IBAction)memberBtnClicked:(UIButton *)sender {
    GXMemberVC *mvc = [GXMemberVC new];
    mvc.mineData = self.mineData;
    [self.navigationController pushViewController:mvc animated:YES];
}
/** 设置 */
- (IBAction)settingBtnClicked:(UIButton *)sender {
    GXMySetVC *svc = [GXMySetVC new];
    svc.mineData = self.mineData;
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
        wvc.navTitle = @"售后标准";
        wvc.isNeedRequest = YES;
        wvc.requestType = 5;
        [self.navigationController pushViewController:wvc animated:YES];
    }else if (sender.tag == 3){
        GXMemberVC *mvc = [GXMemberVC new];
        mvc.mineData = self.mineData;
        [self.navigationController pushViewController:mvc animated:YES];
    }else if (sender.tag == 4){
        GXHelpVC *hvc = [GXHelpVC new];
        [self.navigationController pushViewController:hvc animated:YES];
    }else if (sender.tag == 5){
        GXMyIdeaVC *cvc = [GXMyIdeaVC new];
        [self.navigationController pushViewController:cvc animated:YES];
    }else if (sender.tag == 6){
        //GXComplainVC *cvc = [GXComplainVC new];
        //[self.navigationController pushViewController:cvc animated:YES];
        GXWebContentVC *wvc = [GXWebContentVC new];
        wvc.navTitle = @"我要投诉";
        wvc.isNeedRequest = YES;
        wvc.requestType = 7;
        [self.navigationController pushViewController:wvc animated:YES];
    }else if (sender.tag == 7){
        GXReportVC *rvc = [GXReportVC new];
        [self.navigationController pushViewController:rvc animated:YES];
    }else if (sender.tag == 8){
        FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:@"联系客服" delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[[NSString stringWithFormat:@"%@",self.mineData.platform_tel]]];
        hx_weakify(self);
        [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
            hx_strongify(weakSelf);
            if (selectedIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",strongSelf.mineData.platform_tel]]];
            }
        }];
    }else{
        GXWebContentVC *wvc = [GXWebContentVC new];
        wvc.navTitle = @"申请供货";
        wvc.isNeedRequest = YES;
        wvc.requestType = 2;
        [self.navigationController pushViewController:wvc animated:YES];
    }
}

@end
