//
//  GXTryApplyVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXTryApplyVC.h"
#import "GXActivityBannerHeader.h"
#import "GXTryApplyCell.h"
#import "GXPartnerDataSectionHeader.h"
#import "GXGoodsDetailVC.h"
#import "GXActivityBannerHeader.h"
#import "GXTryGoods.h"

static NSString *const TryApplyCell = @"TryApplyCell";

@interface GXTryApplyVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) GXActivityBannerHeader *header;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 列表 */
@property(nonatomic,strong) NSMutableArray *tryGoods;
@end

@implementation GXTryApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"试用装申请"];
    [self setUpTableView];
    [self setUpRefresh];
    [self startShimmer];
    [self getTryGoodsListDataRequest:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, HX_SCREEN_WIDTH*3/7.0);
}
-(NSMutableArray *)tryGoods
{
    if (_tryGoods == nil) {
        _tryGoods = [NSMutableArray array];
    }
    return _tryGoods;
}
-(GXActivityBannerHeader *)header
{
    if (_header == nil) {
        _header = [GXActivityBannerHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, HX_SCREEN_WIDTH*3/7.0);
    }
    return _header;
}
#pragma mark -- 视图相关
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.rowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = HXGlobalBg;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXTryApplyCell class]) bundle:nil] forCellReuseIdentifier:TryApplyCell];
    
    self.tableView.tableHeaderView = self.header;
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getTryGoodsListDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getTryGoodsListDataRequest:NO];
    }];
}
#pragma mark -- 接口请求
-(void)getTryGoodsListDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"program/getTryGood" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;

                [strongSelf.tryGoods removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXTryGoods class] json:responseObject[@"data"]];
                [strongSelf.tryGoods addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;

                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXTryGoods class] json:responseObject[@"data"]];
                    [strongSelf.tryGoods addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.tableView.hidden = NO;
                strongSelf.header.tryCovers = @[strongSelf.try_cover];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tryGoods.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXTryApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:TryApplyCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GXTryGoods *goods = self.tryGoods[indexPath.row];
    cell.goods = goods;
    hx_weakify(self);
    cell.getTryCall = ^{
        hx_strongify(weakSelf);
        GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
        dvc.goods_id = goods.goods_id;
        [strongSelf.navigationController pushViewController:dvc animated:YES];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 120.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GXPartnerDataSectionHeader *header = [GXPartnerDataSectionHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44.f);
    header.titleLabel.text = @"每周推荐";
    header.moreTitle.hidden = YES;
    
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXTryGoods *goods = self.tryGoods[indexPath.row];
    GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
    dvc.goods_id = goods.goods_id;
    [self.navigationController pushViewController:dvc animated:YES];
}

@end
