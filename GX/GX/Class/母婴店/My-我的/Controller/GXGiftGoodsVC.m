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
#import "GXRenewMyOrderHeader.h"
#import "GXGiftGoodsDetailVC.h"

static NSString *const GiftGoodsCell = @"GiftGoodsCell";
@interface GXGiftGoodsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation GXGiftGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"赠品订单"];
    [self setUpTableView];
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
    
//    hx_weakify(self);
//    [self.tableView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
//        [weakSelf startShimmer];
//        [weakSelf getOrderDataRequest:YES];
//    }];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
//    hx_weakify(self);
//    self.tableView.mj_header.automaticallyChangeAlpha = YES;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        hx_strongify(weakSelf);
//        [strongSelf.tableView.mj_footer resetNoMoreData];
//        [strongSelf getOrderDataRequest:YES];
//    }];
//    //追加尾部刷新
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        hx_strongify(weakSelf);
//        [strongSelf getOrderDataRequest:NO];
//    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
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
    return 80.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GXRenewMyOrderHeader *header = [GXRenewMyOrderHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 80.f);
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section%2) {
        return 50.f;
    }else{
        return 10.f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    /** 待付款 - 取消订单、立即付款  待发货 - 申请退款[线下审核未通过 - 无]  待收货 - 申请退款、查看物流、确认收货  待评价 - 评价  已完成/退款列表 - 无*/
    GXGiftGoodsFooter *footer = [GXGiftGoodsFooter loadXibView];
     if (section%2) {
        footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 50.f);
        footer.handleView.hidden = NO;
    }else{
        footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 10.f);
        footer.handleView.hidden = YES;
    }
    return footer;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXGiftGoodsDetailVC *dvc = [GXGiftGoodsDetailVC new];
    [self.navigationController pushViewController:dvc animated:YES];
}
@end
