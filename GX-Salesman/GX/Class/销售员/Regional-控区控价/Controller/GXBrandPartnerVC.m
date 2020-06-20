//
//  GXBrandPartnerVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXBrandPartnerVC.h"
#import "GXGoodsFilterView.h"
#import <zhPopupController.h>
#import "GXCatalogItem.h"
#import "GXRegionalCell.h"
#import "GXBrandDetailVC.h"
#import "GXGoodBrand.h"

static NSString *const RegionalCell = @"RegionalCell";
@interface GXBrandPartnerVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 列表 */
@property(nonatomic,strong) NSMutableArray *brands;
/* 筛选按钮 */
@property(nonatomic,strong) SPButton *filterBtn;
/* 分类 */
@property(nonatomic,strong) NSArray *catalogItems;
/* 分类视图 */
@property(nonatomic,strong) GXGoodsFilterView *fliterView;
/* 分类id */
@property (nonatomic, copy) NSString *catalog_id;
/* 筛选弹框 */
@property (nonatomic, strong) zhPopupController *fliterPopVC;
@end

@implementation GXBrandPartnerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpRefresh];
    [self startShimmer];
    [self getBrandDataRequest:YES];
    [self getCatalogItemRequest];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
    //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
-(NSMutableArray *)brands
{
    if (_brands == nil) {
        _brands = [NSMutableArray array];
    }
    return _brands;
}
-(void)setCatalog_id:(NSString *)catalog_id
{
    if (![_catalog_id isEqualToString:catalog_id]) {
        _catalog_id = catalog_id;
        [self getBrandDataRequest:YES];
    }
}
-(GXGoodsFilterView *)fliterView
{
    if (_fliterView == nil) {
        _fliterView = [GXGoodsFilterView loadXibView];
        _fliterView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-80, HX_SCREEN_HEIGHT);
    }
    return _fliterView;
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"控区控价品牌"];
    
    SPButton *filter = [SPButton buttonWithType:UIButtonTypeCustom];
    filter.imagePosition = SPButtonImagePositionRight;
    filter.imageTitleSpace = 2.f;
    filter.hxn_size = CGSizeMake(50, 40);
    filter.titleLabel.font = [UIFont systemFontOfSize:13];
    [filter setImage:HXGetImage(@"筛选白") forState:UIControlStateNormal];
    [filter addTarget:self action:@selector(filterClicked) forControlEvents:UIControlEventTouchUpInside];
    [filter setTitleColor:UIColorFromRGB(0XFFFFFF) forState:UIControlStateNormal];
    self.filterBtn = filter;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filter];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXRegionalCell class]) bundle:nil] forCellReuseIdentifier:RegionalCell];
    
    hx_weakify(self);
    [self.tableView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
        [weakSelf startShimmer];
        [weakSelf getBrandDataRequest:YES];
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
        [strongSelf getBrandDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getBrandDataRequest:NO];
    }];
}
#pragma mark -- 获取分类
-(void)getCatalogItemRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"program/getCatalogItem" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.catalogItems = [NSArray yy_modelArrayWithClass:[GXCatalogItem class] json:responseObject[@"data"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 数据请求
-(void)getBrandDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"partType"] = @(2);//1查询已加盟 2查询所有
    parameters[@"catalog_id"] = (self.catalog_id && self.catalog_id.length)?self.catalog_id:@"";//分类筛选
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"program/partBrand" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                
                [strongSelf.brands removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXGoodBrand class] json:responseObject[@"data"]];
                [strongSelf.brands addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXGoodBrand class] json:responseObject[@"data"]];
                    [strongSelf.brands addObjectsFromArray:arrt];
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
#pragma mark -- 点击事件
-(void)filterClicked
{
    if (!self.catalogItems) {
        return;
    }
    
    self.fliterView.dataType = 1;
    self.fliterView.logItemId = self.catalog_id;
    self.fliterView.dataSouce = self.catalogItems;
    hx_weakify(self);
    self.fliterView.sureFilterCall = ^(NSString * _Nonnull cata_id) {
        hx_strongify(weakSelf);
        [strongSelf.fliterPopVC dismissWithDuration:0.25 completion:nil];
        strongSelf.catalog_id = cata_id;
    };
    
    self.fliterPopVC = [[zhPopupController alloc] initWithView:self.fliterView size:self.fliterView.bounds.size];
    self.fliterPopVC.layoutType = zhPopupLayoutTypeRight;
    [self.fliterPopVC show];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.brands.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXRegionalCell *cell = [tableView dequeueReusableCellWithIdentifier:RegionalCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GXGoodBrand *brand = self.brands[indexPath.row];
    cell.brand = brand;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 260.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXBrandDetailVC *dvc = [GXBrandDetailVC new];
    GXGoodBrand *brand = self.brands[indexPath.row];
    dvc.brand_id = brand.brand_id;
    [self.navigationController pushViewController:dvc animated:YES];
}
@end
