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

static NSString *const GiftGoodsCell = @"GiftGoodsCell";
@interface GXGiftGoodsDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) GXOrderDetailHeader *header;
@property (nonatomic, strong) GXGiftGoodsDetailFooter *footer;
@end

@implementation GXGiftGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"赠品订单详情"];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 225);
    self.footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 90.f);
}
-(GXOrderDetailHeader *)header
{
    if (_header == nil) {
        _header = [GXOrderDetailHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 225);
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
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXGiftGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:GiftGoodsCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 75.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 84.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GXMyOrderHeader *header = [GXMyOrderHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 84.f);
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
