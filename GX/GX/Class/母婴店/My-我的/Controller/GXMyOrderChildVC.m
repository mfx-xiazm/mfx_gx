//
//  GXMyOrderChildVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMyOrderChildVC.h"
#import "GXUpOrderGoodsCell.h"
#import "GXMyOrderHeader.h"
#import "GXMyOrderFooter.h"
#import "GXOrderDetailVC.h"
#import "GXMyOrder.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "GXEvaluateVC.h"
#import "GXMyRefund.h"
#import "GXWebContentVC.h"
#import "GXPayTypeVC.h"

static NSString *const UpOrderGoodsCell = @"UpOrderGoodsCell";
@interface GXMyOrderChildVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 订单列表 */
@property(nonatomic,strong) NSMutableArray *orders;
/** 退款列表 */
@property(nonatomic,strong) NSMutableArray *refunds;
/** 当前操作的订单 */
@property(nonatomic,strong) GXMyOrder *currentOrder;
@end

@implementation GXMyOrderChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpRefresh];
    [self startShimmer];
    [self getOrderDataRequest:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.view.hxn_width = HX_SCREEN_WIDTH;
}
-(NSMutableArray *)orders
{
    if (_orders == nil) {
        _orders = [NSMutableArray array];
    }
    return _orders;
}
-(NSMutableArray *)refunds
{
    if (_refunds == nil) {
        _refunds = [NSMutableArray array];
    }
    return _refunds;
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
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getOrderDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getOrderDataRequest:NO];
    }];
}
#pragma mark -- 数据请求
-(void)getOrderDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.status != 6) {// 不是售后退款
        parameters[@"status"] = @(self.status);
    }
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:(self.status != 6)?@"admin/getOrderData":@"admin/orderRefundList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                if (strongSelf.status != 6) {// 不是售后退款
                    [strongSelf.orders removeAllObjects];
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXMyOrder class] json:responseObject[@"data"]];
                    [strongSelf.orders addObjectsFromArray:arrt];
                }else{
                    [strongSelf.refunds removeAllObjects];
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXMyRefund class] json:responseObject[@"data"]];
                    [strongSelf.refunds addObjectsFromArray:arrt];
                }
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    if (strongSelf.status != 6) {// 不是售后退款
                        NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXMyOrder class] json:responseObject[@"data"]];
                        [strongSelf.orders addObjectsFromArray:arrt];
                    }else{
                        NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXMyRefund class] json:responseObject[@"data"]];
                        [strongSelf.refunds addObjectsFromArray:arrt];
                    }
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.tableView.hidden = NO;
                [strongSelf.tableView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/** 取消订单 */
-(void)cancelOrderRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"oid"] = self.currentOrder.oid;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/cancelOrder" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (strongSelf.status == 0) {
                    strongSelf.currentOrder.status = @"已取消";
                }else{
                    [strongSelf.orders removeObject:strongSelf.currentOrder];
                }
                [strongSelf.tableView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/** 申请退款 */
-(void)orderRefundRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"oid"] = self.currentOrder.oid;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/orderRefund" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.orders removeObject:strongSelf.currentOrder];
                [strongSelf.tableView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/** 确认收货 */
-(void)confirmReceiveGoodRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"oid"] = self.currentOrder.oid;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/confirmReceiveGood" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (strongSelf.status == 0) {
                    strongSelf.currentOrder.status = @"待评价";
                }else{
                    [strongSelf.orders removeObject:strongSelf.currentOrder];
                }
                [strongSelf.tableView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.status !=6)?self.orders.count:self.refunds.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.status !=6) {
        GXMyOrder *order = self.orders[section];
        return order.goods.count;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXUpOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:UpOrderGoodsCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.status !=6) {
        GXMyOrder *order = self.orders[indexPath.section];
        GXMyOrderGoods *goods = order.goods[indexPath.row];
        cell.goods = goods;
    }else{
        GXMyRefund *refund = self.refunds[indexPath.section];
        cell.refund = refund;
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
    return 44.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GXMyOrderHeader *header = [GXMyOrderHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44.f);
    if (self.status !=6) {
        GXMyOrder *order = self.orders[section];
        header.order = order;
    }else{
        GXMyRefund *refund = self.refunds[section];
        header.refund = refund;
    }
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.status !=6) {
        GXMyOrder *order = self.orders[section];
        if ([order.pay_type isEqualToString:@"3"]) {//线下付款
            if ([order.status isEqualToString:@"待发货"]) {
                if ([order.approve_status isEqualToString:@"2"]) {//订单审核通过
                    return 80.f;
                }else{
                    return 30.f;
                }
            }else if ([order.status isEqualToString:@"已完成"] || [order.status isEqualToString:@"已取消"]) {
                return 30.f;
            }else{
                return 80.f;
            }
        }else{// 线上付款
            if ([order.status isEqualToString:@"已完成"] || [order.status isEqualToString:@"已取消"]) {
                return 30.f;
            }else{
                return 80.f;
            }
        }
    }else{
        return 30.f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    /** 待付款 - 取消订单、立即付款  待发货 - 申请退款[线下审核未通过 - 无]  待收货 - 申请退款、查看物流、确认收货  待评价 - 评价  已完成/退款列表 - 无*/
    GXMyOrderFooter *footer = [GXMyOrderFooter loadXibView];
    if (self.status !=6) {// 不是退款售后
        GXMyOrder *order = self.orders[section];
        if ([order.pay_type isEqualToString:@"3"]) {//线下付款
            if ([order.status isEqualToString:@"待发货"]) {
                if ([order.approve_status isEqualToString:@"2"]) {//订单审核通过
                    footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 80.f);
                    footer.handleView.hidden = NO;
                }else{
                    footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 30.f);
                    footer.handleView.hidden = YES;
                }
            }else if ([order.status isEqualToString:@"已完成"] || [order.status isEqualToString:@"已取消"]) {
                footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 30.f);
                footer.handleView.hidden = YES;
            }else{
                footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 80.f);
                footer.handleView.hidden = NO;
            }
        }else{// 线上付款
            if ([order.status isEqualToString:@"已完成"] || [order.status isEqualToString:@"已取消"]) {
                footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 30.f);
                footer.handleView.hidden = YES;
            }else{
                footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 80.f);
                footer.handleView.hidden = NO;
            }
        }
        footer.order = order;
        hx_weakify(self);
        footer.orderHandleCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            strongSelf.currentOrder = order;
            /** 待付款 - 取消订单、立即付款  待发货 - 申请退款[线下审核未通过 - 无]  待收货 - 申请退款、查看物流、确认收货  待评价 - 评价  已完成/退款列表 - 无 */
            if (index == 1) {
                if ([order.status isEqualToString:@"待收货"]) {
                    //HXLog(@"申请退款");
                    [strongSelf orderRefundRequest];
                }
            }else if (index == 2){
                if ([order.status isEqualToString:@"待付款"]) {
                    //HXLog(@"取消订单");
                    [strongSelf cancelOrderRequest];
                }else if ([order.status isEqualToString:@"待收货"]) {
                    //HXLog(@"查看物流");
                    GXWebContentVC *cvc = [GXWebContentVC new];
                    cvc.navTitle = @"物流详情";
                    cvc.isNeedRequest = NO;
                    cvc.url = order.url;
                    [strongSelf.navigationController pushViewController:cvc animated:YES];
                }
            }else{
                if ([order.status isEqualToString:@"待付款"]) {
                    //HXLog(@"立即付款");
                    GXPayTypeVC *pvc = [GXPayTypeVC new];
                    pvc.oid = order.oid;
                    pvc.order_no = order.order_no;
                    pvc.isOrderPush = YES;
                    [strongSelf.navigationController pushViewController:pvc animated:YES];
                }else if ([order.status isEqualToString:@"待发货"]) {
                    //HXLog(@"申请退款");
                    [strongSelf orderRefundRequest];
                }else if ([order.status isEqualToString:@"待收货"]) {
                    //HXLog(@"确认收货");
                    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要确认收货吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
                    zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                        [strongSelf.zh_popupController dismiss];
                    }];
                    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确认" handler:^(zhAlertButton * _Nonnull button) {
                        [strongSelf.zh_popupController dismiss];
                        [strongSelf confirmReceiveGoodRequest];
                    }];
                    cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
                    [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                    okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                    [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                    [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
                    strongSelf.zh_popupController = [[zhPopupController alloc] init];
                    [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
                }else if ([order.status isEqualToString:@"待评价"]) {
                    //HXLog(@"评价");
                    GXEvaluateVC *evc = [GXEvaluateVC new];
                    evc.oid = order.oid;
                    evc.evaluatSuccessCall = ^{
                        if (strongSelf.status == 0) {
                            order.status = @"已完成";
                        }else{
                            [strongSelf.orders removeObject:order];
                        }
                        [tableView reloadData];
                    };
                    [strongSelf.navigationController pushViewController:evc animated:YES];
                }
            }
        };
    }else{// 退款售后
        footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 30.f);
        footer.handleView.hidden = YES;
        GXMyRefund *refund = self.refunds[section];
        footer.refund = refund;
    }
    return footer;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXOrderDetailVC *dvc = [GXOrderDetailVC new];
    if (self.status != 6) {
        GXMyOrder *order = self.orders[indexPath.section];
        dvc.oid = order.oid;
        hx_weakify(self);
        dvc.orderHandleCall = ^(NSInteger type) {
            hx_strongify(weakSelf);
            if (strongSelf.status == 0) {
                /* 订单操作  0 取消订单 1支付订单 2申请退款 3确认收货 4评价 */
                if (type == 0) {
                    order.status = @"已取消";
                }else if (type == 1) {
                    order.status = @"待发货";
                }else if (type == 2) {
                    [strongSelf.orders removeObject:order];
                }else if (type == 3) {
                    order.status = @"待评价";
                }else{
                    order.status = @"已完成";
                }
            }else{
                [strongSelf.orders removeObject:order];
            }
            [tableView reloadData];
        };
    }else{
        GXMyRefund *refund = self.refunds[indexPath.section];
        dvc.refund_id = refund.refund_id;
    }
    
    [self.navigationController pushViewController:dvc animated:YES];
}

@end
