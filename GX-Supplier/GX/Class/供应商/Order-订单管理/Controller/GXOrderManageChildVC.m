//
//  GXOrderManageChildVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/8.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXOrderManageChildVC.h"
#import "GXRenewMyOrderBigCell.h"
#import "GXRenewMyOrderHeader.h"
#import "GXRenewMyOrderFooter.h"
#import "GXOrderDetailVC.h"
#import "GXMyOrder.h"
#import "GXMyRefund.h"

static NSString *const UpOrderGoodsCell = @"UpOrderGoodsCell";
@interface GXOrderManageChildVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 订单列表 */
@property(nonatomic,strong) NSMutableArray *orders;
/** 退款列表 */
@property(nonatomic,strong) NSMutableArray *refunds;
@end

@implementation GXOrderManageChildVC

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
-(void)setSeaKey:(NSString *)seaKey
{
    if (![_seaKey isEqualToString:seaKey]) {
        _seaKey = seaKey;
        [self getOrderDataRequest:YES];
    }
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXRenewMyOrderBigCell class]) bundle:nil] forCellReuseIdentifier:UpOrderGoodsCell];
    
    hx_weakify(self);
    [self.tableView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
        [weakSelf startShimmer];
        [weakSelf getOrderDataRequest:YES];
    }];
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
    parameters[@"status"] = @(self.status);
    parameters[@"goods_name"] = (self.seaKey && self.seaKey.length)?self.seaKey:@"";
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"index/getOrderData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                if (strongSelf.status != 5) {// 不是售后退款
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
                    if (strongSelf.status != 5) {// 不是售后退款
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
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.status !=5)?self.orders.count:self.refunds.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXRenewMyOrderBigCell *cell = [tableView dequeueReusableCellWithIdentifier:UpOrderGoodsCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.status = self.status;
    if (self.status != 5) {
        GXMyOrder *order = self.orders[indexPath.section];
        cell.myOrder = order;
    }else{
        GXMyRefund *refund = self.refunds[indexPath.section];
        cell.myRefund = refund;
    }
    hx_weakify(self);
    cell.cellClickedCall = ^{
        hx_strongify(weakSelf);
        GXOrderDetailVC *dvc = [GXOrderDetailVC new];
        if (strongSelf.status != 5) {// 不是退款售后
            GXMyOrder *order = strongSelf.orders[indexPath.section];
            dvc.oid = order.oid;
        }else{// 退款售后
            GXMyRefund *refund = strongSelf.refunds[indexPath.section];
            dvc.refund_id = refund.refund_id;
        }
        [strongSelf.navigationController pushViewController:dvc animated:YES];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    if (self.status != 5) {
        GXMyOrder *order = self.orders[indexPath.section];
        return order.goods.count*110.f + 40.f;
    }else{
        GXMyRefund *refund = self.refunds[indexPath.section];
        return refund.goods.count*110.f + 40.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GXRenewMyOrderHeader *header = [GXRenewMyOrderHeader loadXibView];
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
    return 50.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    GXRenewMyOrderFooter *footer = [GXRenewMyOrderFooter loadXibView];
    footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 50.f);
    footer.handleView.hidden = YES;
    if (self.status != 5) {// 不是退款售后
        GXMyOrder *order = self.orders[section];
        footer.pOrder = order;
    }else{// 退款售后
        GXMyRefund *refund = self.refunds[section];
        footer.pRefund = refund;
    }
    return footer;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
