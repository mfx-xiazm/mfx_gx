//
//  GXGiftGoodsVC.m
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXGiftGoodsVC.h"
#import "GXGiftGoodsCell.h"
#import "GXGiftGoodsFooter.h"
#import "GXGiftGoodsHeader.h"
#import "GXGiftGoodsDetailVC.h"
#import "GXGiftGoods.h"
#import "GXWebContentVC.h"
#import "zhAlertView.h"
#import <zhPopupController.h>

static NSString *const GiftGoodsCell = @"GiftGoodsCell";
@interface GXGiftGoodsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 赠品列表 */
@property(nonatomic,strong) NSMutableArray *gifts;
/** 弹框 */
@property (nonatomic, strong) zhPopupController *alertPopVC;
@end

@implementation GXGiftGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"赠品订单"];
    [self setUpTableView];
    [self setUpRefresh];
    [self startShimmer];
    [self getGiftDataRequest:YES];
}
-(NSMutableArray *)gifts
{
    if (!_gifts) {
        _gifts = [NSMutableArray array];
    }
    return _gifts;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXGiftGoodsCell class]) bundle:nil] forCellReuseIdentifier:GiftGoodsCell];
    
    hx_weakify(self);
    [self.tableView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
        [weakSelf startShimmer];
        [weakSelf getGiftDataRequest:YES];
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
        [strongSelf getGiftDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getGiftDataRequest:NO];
    }];
}
#pragma mark -- 数据请求
-(void)getGiftDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getGiftOrder" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.gifts removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXGiftGoods class] json:responseObject[@"data"]];
                [strongSelf.gifts addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXGiftGoods class] json:responseObject[@"data"]];
                    [strongSelf.gifts addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
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
/** 确认收货 */
-(void)confirmReceiveGoodRequest:(GXGiftGoods *)giftGoods
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"gift_order_id"] = giftGoods.gift_order_id;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/confirmReceiveGiftGood" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                giftGoods.gift_order_status = @"已完成";
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
    return self.gifts.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXGiftGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:GiftGoodsCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GXGiftGoods *giftGoods = self.gifts[indexPath.section];
    cell.giftGoods = giftGoods;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 75.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GXGiftGoodsHeader *header = [GXGiftGoodsHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 80.f);
    GXGiftGoods *giftGoods = self.gifts[section];
    header.giftGoods = giftGoods;
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.gifts && self.gifts.count) {
        GXGiftGoods *giftGoods = self.gifts[section];
        if ([giftGoods.gift_order_status isEqualToString:@"待收货"]) {
            return 50.f;
        }else{
            return 10.f;
        }
    }else{
        return 10.f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    /** 待付款 - 取消订单、立即付款  待发货 - 申请退款[线下审核未通过 - 无]  待收货 - 申请退款、查看物流、确认收货  待评价 - 评价  已完成/退款列表 - 无*/
    GXGiftGoodsFooter *footer = [GXGiftGoodsFooter loadXibView];
    GXGiftGoods *giftGoods = self.gifts[section];
    if ([giftGoods.gift_order_status isEqualToString:@"待收货"]) {
        footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 50.f);
        footer.handleView.hidden = NO;
    }else{
        footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 10.f);
        footer.handleView.hidden = YES;
    }
    hx_weakify(self);
    footer.giftClickedCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        if (index == 1) {
            zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要确认收货吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
            zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                [strongSelf.alertPopVC dismiss];
            }];
            zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确认" handler:^(zhAlertButton * _Nonnull button) {
                [strongSelf.alertPopVC dismiss];
                [strongSelf confirmReceiveGoodRequest:giftGoods];
            }];
            cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            okButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
            [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
            strongSelf.alertPopVC = [[zhPopupController alloc] initWithView:alert size:alert.bounds.size];
            [strongSelf.alertPopVC show];
        }else{
            if (giftGoods.logistics_no && giftGoods.logistics_no.length) {
                GXWebContentVC *cvc = [GXWebContentVC new];
                cvc.navTitle = @"物流详情";
                cvc.isNeedRequest = NO;
                cvc.url = giftGoods.url;
                [strongSelf.navigationController pushViewController:cvc animated:YES];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请联系快递公司"];
            }
        }
    };
    return footer;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXGiftGoodsDetailVC *dvc = [GXGiftGoodsDetailVC new];
    GXGiftGoods *giftGoods = self.gifts[indexPath.section];
    dvc.gift_order_id = giftGoods.gift_order_id;
    dvc.statusChangeCall = ^{
        giftGoods.gift_order_status = @"已完成";
        [tableView reloadData];
    };
    [self.navigationController pushViewController:dvc animated:YES];
}
@end
