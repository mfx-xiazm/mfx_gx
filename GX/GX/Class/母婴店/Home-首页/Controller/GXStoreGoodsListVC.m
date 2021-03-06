//
//  GXStoreGoodsListVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXStoreGoodsListVC.h"
#import "GXStoreGoodsListHeader.h"
#import "GXPageMainTable.h"
#import <JXCategoryView.h>
#import "GXStoreGoodsChildVC.h"
#import "GXStore.h"
#import "GXCatalogItem.h"
#import "GXStoreMsgVC.h"
#import "GXSearchResultVC.h"
#import "HXSearchBar.h"

@interface GXStoreGoodsListVC ()<UITableViewDelegate,UITableViewDataSource,JXCategoryViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet GXPageMainTable *tableView;
/* 头视图 */
@property(nonatomic,strong) GXStoreGoodsListHeader *header;
/** 子控制器承载scr */
@property (nonatomic,strong) UIScrollView *scrollView;
/** 子控制器数组 */
@property (nonatomic,strong) NSArray *childVCs;
/** 是否可以滑动 */
@property(nonatomic,assign)BOOL isCanScroll;
/** 切换控制器 */
@property (strong, nonatomic) JXCategoryTitleView *categoryView;
/** 店铺基本信息 */
@property(nonatomic,strong) GXStore *storeInfo;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
@end

@implementation GXStoreGoodsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];

    self.isCanScroll = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MainTableScroll:) name:@"MainTableScroll" object:nil];
    [self setUpMainTable];
    [self startShimmer];
    [self getShopInfoRequest];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(GXStoreGoodsListHeader *)header
{
    if (_header == nil) {
        _header = [GXStoreGoodsListHeader loadXibView];
        _header.frame = CGRectMake(0,0, HX_SCREEN_WIDTH, 120.f);
    }
    return _header;
}
-(JXCategoryTitleView *)categoryView
{
    if (_categoryView == nil) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 44);
        _categoryView.backgroundColor = [UIColor whiteColor];
        NSMutableArray *titles = [NSMutableArray array];
        for (GXCatalogItem *item in self.storeInfo.catalog) {
            [titles addObject:item.catalog_name];
        }
        _categoryView.titles = titles;
        _categoryView.titleFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _categoryView.titleColor = [UIColor blackColor];
        _categoryView.titleSelectedColor = HXControlBg;
        _categoryView.delegate = self;
        _categoryView.contentScrollView = self.scrollView;
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.verticalMargin = 5.f;
        lineView.indicatorColor = HXControlBg;
        _categoryView.indicators = @[lineView];
    }
    return _categoryView;
}
-(NSArray *)childVCs
{
    if (_childVCs == nil) {
        NSMutableArray *vcs = [NSMutableArray array];
        
        for (int i=0; i<self.categoryView.titles.count; i++) {
            GXStoreGoodsChildVC *cvc = [GXStoreGoodsChildVC new];
            cvc.provider_uid = self.provider_uid;
            GXCatalogItem *item = self.storeInfo.catalog[i];
            cvc.catalog_id = item.catalog_id;
            [self addChildViewController:cvc];
            [vcs addObject:cvc];
        }
        _childVCs = vcs;
    }
    return _childVCs;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 44, HX_SCREEN_WIDTH, HX_SCREEN_HEIGHT-self.HXNavBarHeight-self.HXButtomHeight - 44);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(HX_SCREEN_WIDTH*self.childVCs.count, 0);
        _scrollView.bounces = NO;
        // 加第一个视图
        UIViewController *targetViewController = self.childVCs.firstObject;
        targetViewController.view.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, _scrollView.hxn_height);
        [_scrollView addSubview:targetViewController.view];
    }
    return  _scrollView;
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH - 70.f, 30.f)];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 15.f;
    searchBar.layer.masksToBounds = YES;
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入商品名称查询";
    self.searchBar = searchBar;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
}
-(void)setUpMainTable
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
    self.tableView.contentInset = UIEdgeInsetsMake(120.f,0, 0, 0);
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = HXGlobalBg;
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView addSubview:self.header];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField hasText]) {
        [textField resignFirstResponder];

        GXSearchResultVC *gvc = [GXSearchResultVC new];
        gvc.keyword = textField.text;
        gvc.provider_uid = self.provider_uid;
        [self.navigationController pushViewController:gvc animated:YES];
        return YES;
    }else{
        return NO;
    }
}
#pragma mark -- 接口请求
-(void)getShopInfoRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"provider_uid"] = self.provider_uid;// 店铺id
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/shopData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.storeInfo = [GXStore yy_modelWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleStoreInfo];
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
-(void)handleStoreInfo
{
    if (self.storeInfo.coupon && self.storeInfo.coupon.count) {
        self.tableView.contentInset = UIEdgeInsetsMake(120.f+60.f,0, 0, 0);
        self.header.frame = CGRectMake(0, -(120.f+60.f), HX_SCREEN_WIDTH, 120.f+60.f);
    }else{
        self.tableView.contentInset = UIEdgeInsetsMake(120.f,0, 0, 0);
        self.header.frame = CGRectMake(0, -(120.f), HX_SCREEN_WIDTH, 120.f);
    }
    hx_weakify(self);
    self.header.storeMsgCall = ^{
        hx_strongify(weakSelf);
        GXStoreMsgVC *mvc = [GXStoreMsgVC new];
        mvc.provider_uid = strongSelf.provider_uid;
        [strongSelf.navigationController pushViewController:mvc animated:YES];
    };
    self.header.storeInfo = self.storeInfo;
    [self.tableView reloadData];
}
#pragma mark -- 主视图滑动通知处理
-(void)MainTableScroll:(NSNotification *)user{
    self.isCanScroll = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        CGFloat tabOffsetY = [self.tableView rectForSection:0].origin.y;
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY>=tabOffsetY) {
            self.isCanScroll = NO;
            scrollView.contentOffset = CGPointMake(0, 0);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"childScrollCan" object:nil];
        }else{
            if (!self.isCanScroll) {
                [scrollView setContentOffset:CGPointZero];
            }
        }
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - JXCategoryViewDelegate
// 滚动和点击选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    if (self.childVCs.count <= index) {return;}
    
    UIViewController *targetViewController = self.childVCs[index];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(HX_SCREEN_WIDTH * index, 0, HX_SCREEN_WIDTH, self.scrollView.hxn_height);
    
    [self.scrollView addSubview:targetViewController.view];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.storeInfo?1:0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.hxn_height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:self.categoryView];
    // 添加pageView
    [cell.contentView addSubview:self.scrollView];
    
    return cell;
}
@end
