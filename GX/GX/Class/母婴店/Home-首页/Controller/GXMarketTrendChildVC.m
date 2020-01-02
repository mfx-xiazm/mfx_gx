//
//  GXMarketTrendChildVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMarketTrendChildVC.h"
#import "GXMarketTrendCell.h"
#import "GXMarketTrendSectionHeader.h"
#import "GXMarketTrendHeader.h"
#import "GXGoodsDetailVC.h"
#import "GXMarketTrend.h"
#import "GXUpOrderVC.h"

static NSString *const MarketTrendCell = @"MarketTrendCell";
@interface GXMarketTrendChildVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) GXMarketTrendHeader *header;
/* 是否向下滑动*/
@property(nonatomic,assign) BOOL isScrollDown;
/* 行情 */
@property(nonatomic,strong) NSArray *trends;
/* 处理过系列数组 */
@property(nonatomic,strong) NSMutableArray *showTrends;
@end

@implementation GXMarketTrendChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    // 初始化
    self.isScrollDown = YES;
    [self startShimmer];
    [self getCurrencyQuotationsRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.view.hxn_width = HX_SCREEN_WIDTH;
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 140.f);
}
-(NSMutableArray *)showTrends
{
    if (_showTrends == nil) {
        _showTrends = [NSMutableArray array];
    }
    return _showTrends;
}
-(GXMarketTrendHeader *)header
{
    if (_header == nil) {
        _header = [GXMarketTrendHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 140.f);
        [_header.topImg sd_setImageWithURL:[NSURL URLWithString:self.trend_img]];
        hx_weakify(self);
        _header.cateClickedCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            GXMarketTrend *trend = strongSelf.trends[index];
            [strongSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:trend.series_section-1] animated:YES scrollPosition:UITableViewScrollPositionTop];
        };
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
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXMarketTrendCell class]) bundle:nil] forCellReuseIdentifier:MarketTrendCell];
    
    self.tableView.tableHeaderView = self.header;
}
#pragma mark -- 接口请求
-(void)getCurrencyQuotationsRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"catalog_name"] = (self.dataType == 1)?@"奶粉":@"纸尿裤";//分类名称
    hx_weakify(self);
    
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/currencyQuotations" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.trends = [NSArray yy_modelArrayWithClass:[GXMarketTrend class] json:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleTrendData];
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
-(void)handleTrendData
{
    self.header.trends = self.trends;

    NSInteger series_section = 0;
    for (int i=0; i<self.trends.count; i++) {
        GXMarketTrend *trend = self.trends[i];
        series_section += trend.series.count;
        trend.series_section = series_section;
        for (GXMarketTrendSeries *serie in trend.series) {
            serie.section_flag = i;
        }
        [self.showTrends addObjectsFromArray:trend.series];
    }
    
    [self.tableView reloadData];
}
#pragma mark -- 业务逻辑
-(void)addOrderCartRequest:(NSString *)goods_id specs_attrs:(NSString *)specs_attrs logistics_com_id:(NSString *)logistics_com_id sku_id:(NSString *)sku_id
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = goods_id;//商品id
    parameters[@"cart_num"] = @(1);//商品数量
    parameters[@"specs_attrs"] = specs_attrs;//商品规格
    parameters[@"is_try"] = @(0);//是否试用装商品
    parameters[@"is_checked"] = @"1";//0未选择；1已选择
    parameters[@"logistics_com_id"] = logistics_com_id;
    parameters[@"sku_id"] = sku_id;

    [HXNetworkTool POST:HXRC_M_URL action:@"admin/addOrderCart" parameters:parameters success:^(id responseObject) {
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UIScrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat lastOffsetY = 0;

    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 判断滚动方向是向上还是向下
    self.isScrollDown = lastOffsetY < offsetY;
    lastOffsetY = scrollView.contentOffset.y;
    
    // 判断分类视图是否需要悬停
    if (offsetY >= 100) {
        //HXLog(@"悬停");
        self.header.categoryView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 40.f);
        [self.view addSubview:self.header.categoryView];
    }else{
        //HXLog(@"离开悬停");
        self.header.categoryView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 40.f);
        [self.header.cateSuperView addSubview:self.header.categoryView];
    }
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.showTrends.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GXMarketTrendSeries *series = self.showTrends[section];
    return series.goods.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXMarketTrendCell *cell = [tableView dequeueReusableCellWithIdentifier:MarketTrendCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GXMarketTrendSeries *series = self.showTrends[indexPath.section];
    GXSeriesGoods *goods = series.goods[indexPath.row];
    cell.goods = goods;
    hx_weakify(self);
    cell.trendBtnCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        if (index == 1) {
            [strongSelf addOrderCartRequest:goods.goods_id specs_attrs:[NSString stringWithFormat:@"%@,%@",goods.specs_attrs,goods.logistics_com_name] logistics_com_id:goods.logistics_com_id sku_id:goods.sku_id];
        }else{
            GXUpOrderVC *ovc = [GXUpOrderVC new];
            ovc.goods_id = goods.goods_id;
            ovc.goods_num = @"1";
            ovc.specs_attrs = [NSString stringWithFormat:@"%@,%@",goods.specs_attrs,goods.logistics_com_name];
            ovc.sku_id = goods.sku_id;
            ovc.logistics_com_id = goods.logistics_com_id;
            [strongSelf.navigationController pushViewController:ovc animated:YES];
        }
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 65.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GXMarketTrendSectionHeader *header = [GXMarketTrendSectionHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 40.f);
    GXMarketTrendSeries *series = self.showTrends[section];
    header.series = series;
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
    GXMarketTrendSeries *series = self.showTrends[indexPath.section];
    GXSeriesGoods *goods = series.goods[indexPath.row];
    dvc.goods_id = goods.goods_id;
    [self.navigationController pushViewController:dvc animated:YES];
}
// TableView分区标题即将展示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
//当前的tableView滚动的方向向上，并且是用户拖拽而产生滚动的（（主要判断tableView用户拖拽而滚动的，还是点击分类而滚动的）
    if (!self.isScrollDown
        && (tableView.dragging || tableView.decelerating)) {
        GXMarketTrendSeries *series = self.showTrends[section];//通过展示的组来获取真实的组
        [self.header.categoryView selectItemAtIndex:series.section_flag];
    }
}

// TableView分区标题展示结束
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
//当前的tableView滚动的方向向下，并且是用户拖拽而产生滚动的（（主要判断tableView用户拖拽而滚动的，还是点击分类而滚动的）
    if (self.isScrollDown && tableView.dragging) {
        GXMarketTrendSeries *series = self.showTrends[section+1];//通过展示的组来获取真实的组
        [self.header.categoryView selectItemAtIndex:series.section_flag];
    }
}

@end
