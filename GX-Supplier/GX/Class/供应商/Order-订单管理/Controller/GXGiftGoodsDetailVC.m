//
//  GXGiftGoodsDetailVC.m
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXGiftGoodsDetailVC.h"
#import "GXGiftGoodsCell.h"
#import "GXOrderDetailHeader.h"
#import "GXMyOrderHeader.h"
#import "GXGiftGoodsDetailFooter.h"
#import "GXGiftGoods.h"
#import "GXWebContentVC.h"
#import "zhAlertView.h"
#import <zhPopupController.h>

static NSString *const GiftGoodsCell = @"GiftGoodsCell";
@interface GXGiftGoodsDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) GXOrderDetailHeader *header;
@property (nonatomic, strong) GXGiftGoodsDetailFooter *footer;
@property (nonatomic, strong) GXGiftGoods *giftGoods;
@end

@implementation GXGiftGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"赠品订单详情"];
    [self setUpTableView];
    [self startShimmer];
    [self getGiftOrderInfoRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 275);
    self.footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 90.f);
}
-(GXOrderDetailHeader *)header
{
    if (_header == nil) {
        _header = [GXOrderDetailHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 275);
    }
    return _header;
}
-(GXGiftGoodsDetailFooter *)footer
{
    if (_footer == nil) {
        _footer = [GXGiftGoodsDetailFooter loadXibView];
        _footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 90.f);
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXGiftGoodsCell class]) bundle:nil] forCellReuseIdentifier:GiftGoodsCell];
    
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
}
#pragma mark -- 接口请求
-(void)getGiftOrderInfoRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"gift_order_id"] = self.gift_order_id;

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"index/getGiftOrderDetail" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.giftGoods = [GXGiftGoods yy_modelWithDictionary:responseObject[@"data"]];
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
    self.header.giftGoods = self.giftGoods;
    hx_weakify(self);
    self.header.lookLogisCall = ^{
        hx_strongify(weakSelf);
        //HXLog(@"查看物流");
        GXWebContentVC *cvc = [GXWebContentVC new];
        cvc.navTitle = @"物流详情";
        cvc.isNeedRequest = NO;
        cvc.url = strongSelf.giftGoods.url;
        [strongSelf.navigationController pushViewController:cvc animated:YES];
    };
    
    self.footer.giftGoods = self.giftGoods;
   
    [self.tableView reloadData];
}

#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXGiftGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:GiftGoodsCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.sharw_img.hidden = YES;
    cell.giftGoods = self.giftGoods;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 75.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GXMyOrderHeader *header = [GXMyOrderHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 40.f);
    header.giftGoods = self.giftGoods;
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [UIView new];
    footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 10.f);
    footer.backgroundColor = UIColorFromRGB(0xF3F3F3);
    
    return footer;
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
