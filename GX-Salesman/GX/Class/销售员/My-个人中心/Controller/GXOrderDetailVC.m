//
//  GXOrderDetailVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXOrderDetailVC.h"
#import "GXOrderDetailHeader.h"
#import "GXUpOrderGoodsCell.h"
#import "GXMyOrderHeader.h"
#import "GXOrderDetailFooter.h"
#import "GXRefundDetailFooter.h"
#import "GXMyOrder.h"
#import "GXWebContentVC.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "GXMyRefund.h"
#import "GXUpOrderCellSectionFooter.h"

static NSString *const UpOrderGoodsCell = @"UpOrderGoodsCell";
@interface GXOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) GXOrderDetailHeader *header;
/* 退款状态尾部视图 */
@property(nonatomic,strong) GXRefundDetailFooter *footer;
/* 订单详情 */
@property(nonatomic,strong) GXMyOrder *orderDetail;
/* 退款详情 */
@property(nonatomic,strong) GXMyRefund *refundDetail;
/* 订单操作视图 */
@property (weak, nonatomic) IBOutlet UIView *handleView;
/* 订单操作视图高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *handleViewHeight;
/* 订单操作第一个按钮 */
@property (weak, nonatomic) IBOutlet UIButton *firstHandleBtn;
/* 订单操作第二个按钮 */
@property (weak, nonatomic) IBOutlet UIButton *secondHandleBtn;
/* 订单操作第三个按钮 */
@property (weak, nonatomic) IBOutlet UIButton *thirdHandleBtn;
@end

@implementation GXOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"订单详情"];
    [self setUpTableView];
    [self startShimmer];
    [self getOrderInfoRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 275);
    self.footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 130);

}
-(GXOrderDetailHeader *)header
{
    if (_header == nil) {
        _header = [GXOrderDetailHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 275);
    }
    return _header;
}
-(GXRefundDetailFooter *)footer
{
    if (_footer == nil) {
        _footer = [GXRefundDetailFooter loadXibView];
        _footer.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 130);
    }
    return _footer;
}
-(void)setUpTableView
{
    self.tableView.rowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXUpOrderGoodsCell class]) bundle:nil] forCellReuseIdentifier:UpOrderGoodsCell];
    
    self.tableView.tableHeaderView = self.header;
}
#pragma mark -- 接口请求
-(void)getOrderInfoRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.refund_id && self.refund_id.length) {
        parameters[@"refund_id"] = self.refund_id;
    }else{
        parameters[@"oid"] = self.oid;
    }
    NSString *action = nil;
    if ([[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"1"]) {//母婴店
        action = (self.refund_id && self.refund_id.length)?@"program/orderRefundInfo":@"program/getOrderInfo";
    }else if ([[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"2"]) {//供应商
        action = (self.refund_id && self.refund_id.length)?@"index/orderRefundInfo":@"index/getOrderInfo";
    }else{
        action = @"program/getOrderInfo";
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:action parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (strongSelf.refund_id && strongSelf.refund_id.length) {
                strongSelf.refundDetail = [GXMyRefund yy_modelWithDictionary:responseObject[@"data"]];
            }else{
                strongSelf.orderDetail = [GXMyOrder yy_modelWithDictionary:responseObject[@"data"]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleOrderDetailData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)handleOrderDetailData
{
    self.tableView.hidden = NO;
    
    if (self.refund_id && self.refund_id.length) {
        self.refundDetail.isRefundDetail = YES;
    }else{
        self.orderDetail.isDetailOrder = YES;
    }
    
    if ([[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"1"]) {//母婴店
        if (self.refund_id && self.refund_id.length) {
            if ([self.refundDetail.refund_status isEqualToString:@"4"] || [self.refundDetail.refund_status isEqualToString:@"6"]) {
                self.handleView.hidden = NO;
                self.handleViewHeight.constant = 50.f;
                
                self.firstHandleBtn.hidden = YES;
                self.secondHandleBtn.hidden = YES;
                
                self.thirdHandleBtn.hidden = NO;
                [self.thirdHandleBtn setTitle:@"查看原因" forState:UIControlStateNormal];
                self.thirdHandleBtn.backgroundColor = [UIColor whiteColor];
                self.thirdHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                [self.thirdHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                self.handleView.hidden = YES;
                self.handleViewHeight.constant = 0.f;
                self.firstHandleBtn.hidden = YES;
                self.secondHandleBtn.hidden = YES;
                self.thirdHandleBtn.hidden = YES;
            }
            
            self.header.refundDetail = self.refundDetail;
            hx_weakify(self);
            self.header.lookLogisCall = ^{
                hx_strongify(weakSelf);
                //HXLog(@"查看物流");
                GXWebContentVC *cvc = [GXWebContentVC new];
                cvc.navTitle = @"物流详情";
                cvc.isNeedRequest = NO;
                cvc.url = strongSelf.refundDetail.url;
                [strongSelf.navigationController pushViewController:cvc animated:YES];
            };
            
            if (self.refundDetail.address) {
                self.footer.refundDetail = self.refundDetail;// 退款地址
                self.tableView.tableFooterView = self.footer;
            }
                
        }else{
            if ([self.orderDetail.status isEqualToString:@"待付款"]) {
                self.handleView.hidden = NO;
                self.handleViewHeight.constant = 50.f;
                
                self.firstHandleBtn.hidden = YES;
                
                self.secondHandleBtn.hidden = YES;
//                self.secondHandleBtn.hidden = NO;
//                [self.secondHandleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
//                self.secondHandleBtn.backgroundColor = [UIColor whiteColor];
//                self.secondHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
//                [self.secondHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                self.thirdHandleBtn.hidden = NO;
                [self.thirdHandleBtn setTitle:@"立即支付" forState:UIControlStateNormal];
                self.thirdHandleBtn.backgroundColor = HXControlBg;
                self.thirdHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
                [self.thirdHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            }else if ([self.orderDetail.status isEqualToString:@"待发货"]) {
                if ([self.orderDetail.pay_type isEqualToString:@"3"]) {// 线下付款
                    if ([self.orderDetail.approve_status isEqualToString:@"2"]) {//订单审核通过
                        self.handleView.hidden = NO;
                        self.handleViewHeight.constant = 50.f;
                        
                        self.firstHandleBtn.hidden = YES;
                        self.secondHandleBtn.hidden = YES;
                        
                        self.thirdHandleBtn.hidden = NO;
                        [self.thirdHandleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                        self.thirdHandleBtn.backgroundColor = [UIColor whiteColor];
                        self.thirdHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                        [self.thirdHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }else{
                        self.handleView.hidden = YES;
                        self.handleViewHeight.constant = 0.f;
                        
                        self.firstHandleBtn.hidden = YES;
                        self.secondHandleBtn.hidden = YES;
                        self.thirdHandleBtn.hidden = YES;
                    }
                }else{
                    self.handleView.hidden = NO;
                    self.handleViewHeight.constant = 50.f;
                    
                    self.firstHandleBtn.hidden = YES;
                    self.secondHandleBtn.hidden = YES;
                    
                    self.thirdHandleBtn.hidden = NO;
                    [self.thirdHandleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                    self.thirdHandleBtn.backgroundColor = [UIColor whiteColor];
                    self.thirdHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                    [self.thirdHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
            }else if ([self.orderDetail.status isEqualToString:@"待收货"]) {
                self.handleView.hidden = NO;
                self.handleViewHeight.constant = 50.f;
                
                self.firstHandleBtn.hidden = NO;
                [self.firstHandleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                self.firstHandleBtn.backgroundColor = [UIColor whiteColor];
                self.firstHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                [self.firstHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                self.secondHandleBtn.hidden = NO;
                [self.secondHandleBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                self.secondHandleBtn.backgroundColor = [UIColor whiteColor];
                self.secondHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                [self.secondHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                self.thirdHandleBtn.hidden = NO;
                [self.thirdHandleBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                self.thirdHandleBtn.backgroundColor = HXControlBg;
                self.thirdHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
                [self.thirdHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else if ([self.orderDetail.status isEqualToString:@"待评价"]) {
                self.handleView.hidden = NO;
                self.handleViewHeight.constant = 50.f;
                
                self.firstHandleBtn.hidden = YES;
                self.secondHandleBtn.hidden = YES;
                
                self.thirdHandleBtn.hidden = NO;
                [self.thirdHandleBtn setTitle:@"评价" forState:UIControlStateNormal];
                self.thirdHandleBtn.backgroundColor = HXControlBg;
                self.thirdHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
                [self.thirdHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            }else{
                self.handleView.hidden = YES;
                self.handleViewHeight.constant = 0.f;
                
                self.firstHandleBtn.hidden = YES;
                self.secondHandleBtn.hidden = YES;
                self.thirdHandleBtn.hidden = YES;
            }
            
            self.header.orderDetail = self.orderDetail;
            hx_weakify(self);
            self.header.lookLogisCall = ^{
                hx_strongify(weakSelf);
                //HXLog(@"查看物流");
                GXWebContentVC *cvc = [GXWebContentVC new];
                cvc.navTitle = @"物流详情";
                cvc.isNeedRequest = NO;
                cvc.url = strongSelf.orderDetail.url;
                [strongSelf.navigationController pushViewController:cvc animated:YES];
            };
        }
    }else {//供应商或者销售员
        if (self.refund_id && self.refund_id.length) {
            if ([self.refundDetail.refund_status isEqualToString:@"4"] || [self.refundDetail.refund_status isEqualToString:@"6"]) {
                self.handleView.hidden = NO;
                self.handleViewHeight.constant = 50.f;
                
                self.firstHandleBtn.hidden = YES;
                self.secondHandleBtn.hidden = YES;
                
                self.thirdHandleBtn.hidden = NO;
                [self.thirdHandleBtn setTitle:@"查看原因" forState:UIControlStateNormal];
                self.thirdHandleBtn.backgroundColor = [UIColor whiteColor];
                self.thirdHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                [self.thirdHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                self.handleView.hidden = YES;
                self.handleViewHeight.constant = 0.f;
                self.firstHandleBtn.hidden = YES;
                self.secondHandleBtn.hidden = YES;
                self.thirdHandleBtn.hidden = YES;
            }
            
            self.header.refundDetail = self.refundDetail;
            hx_weakify(self);
            self.header.lookLogisCall = ^{
                hx_strongify(weakSelf);
                //HXLog(@"查看物流");
                GXWebContentVC *cvc = [GXWebContentVC new];
                cvc.navTitle = @"物流详情";
                cvc.isNeedRequest = NO;
                cvc.url = strongSelf.refundDetail.url;
                [strongSelf.navigationController pushViewController:cvc animated:YES];
            };
            if (self.refundDetail.address) {
                self.footer.refundDetail = self.refundDetail;// 退款地址
                self.tableView.tableFooterView = self.footer;
            }
        }else{
            self.handleView.hidden = YES;
            self.handleViewHeight.constant = 0.f;
            self.firstHandleBtn.hidden = YES;
            self.secondHandleBtn.hidden = YES;
            self.thirdHandleBtn.hidden = YES;
            
            self.header.orderDetail = self.orderDetail;
            hx_weakify(self);
            self.header.lookLogisCall = ^{
                hx_strongify(weakSelf);
                //HXLog(@"查看物流");
                GXWebContentVC *cvc = [GXWebContentVC new];
                cvc.navTitle = @"物流详情";
                cvc.isNeedRequest = NO;
                cvc.url = strongSelf.orderDetail.url;
                [strongSelf.navigationController pushViewController:cvc animated:YES];
            };
        }
    }
    
    [self.tableView reloadData];
}
#pragma mark -- 点击事件
- (IBAction)orderHandleBtnClicked:(UIButton *)sender {
    
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;//根据实际情况数量要加1
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section != 1) {//不是最后一组
        if (self.refund_id && self.refund_id.length) {
            return self.refundDetail.goods.count;
        }else{
            return self.orderDetail.goods.count;
        }
    }else{//最后一组
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXUpOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:UpOrderGoodsCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.refund_id && self.refund_id.length) {
        GYMyRefundGoods *refundGoods = self.refundDetail.goods[indexPath.row];
        cell.refundGoods = refundGoods;
    }else{
        GXMyOrderGoods *goods = self.orderDetail.goods[indexPath.row];
        goods.refund_status = self.orderDetail.refund_status;
        goods.status = self.orderDetail.status;
        cell.goods = goods;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 110.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 1) {//不是最后一组
        return 40.f;
    }else{//最后一组
        return CGFLOAT_MIN;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GXMyOrderHeader *header = [GXMyOrderHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 40.f);
    if (self.refund_id && self.refund_id.length) {
        self.refundDetail.isRefundDetail = YES;
        header.refund = self.refundDetail;
    }else{
        self.orderDetail.isDetailOrder = YES;
        header.order = self.orderDetail;
    }
    if (section != 1) {//不是最后一组
        return header;
    }else{//最后一组
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section != 1) {//不是最后一组
        return 160.f;
    }else{//最后一组
        return 250.f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section != 1) {//不是最后一组
        GXUpOrderCellSectionFooter *footer = [GXUpOrderCellSectionFooter loadXibView];
        footer.hxn_size = CGSizeMake(tableView.hxn_width, 160.f);
        return footer;
    }else{//最后一组
        GXOrderDetailFooter *footer = [GXOrderDetailFooter loadXibView];
        footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 230.f);
        if (self.refund_id && self.refund_id.length) {
            footer.refundDetail = self.refundDetail;
        }else{
            footer.orderDetail = self.orderDetail;
        }
        return footer;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
//    if (self.refund_id && self.refund_id.length) {
//        GYMyRefundGoods *refundGoods = self.refundDetail.goods[indexPath.row];
//        dvc.goods_id = refundGoods.goods_id;
//    }else{
//        GXMyOrderGoods *goods = self.orderDetail.goods[indexPath.row];
//        dvc.goods_id = goods.goods_id;
//    }
//    [self.navigationController pushViewController:dvc animated:YES];
}


@end
