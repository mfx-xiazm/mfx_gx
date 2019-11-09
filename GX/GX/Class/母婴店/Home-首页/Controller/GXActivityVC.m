//
//  GXActivityVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXActivityVC.h"
#import "GXActivityChildVC.h"
#import "GXActivityBannerHeader.h"
#import "GXPageMainTable.h"
#import <JXCategoryView.h>
#import "HXSearchBar.h"
#import "GXActivityCataInfo.h"
#import "GXCatalogItem.h"
#import "GXSearchActivityVC.h"
#import "GXWebContentVC.h"
#import "GXGoodsDetailVC.h"

@interface GXActivityVC ()<UITableViewDelegate,UITableViewDataSource,JXCategoryViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet GXPageMainTable *tableView;
/* 头视图 */
@property(nonatomic,strong) GXActivityBannerHeader *header;
/** 子控制器承载scr */
@property (nonatomic,strong) UIScrollView *scrollView;
/** 子控制器数组 */
@property (nonatomic,strong) NSArray *childVCs;
/** 是否可以滑动 */
@property(nonatomic,assign)BOOL isCanScroll;
/** 切换控制器 */
@property (strong, nonatomic) JXCategoryTitleView *categoryView;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
/* 活动 */
@property(nonatomic,strong) GXActivityCataInfo *activityInfo;
@end

@implementation GXActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    self.isCanScroll = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MainTableScroll:) name:@"MainTableScroll" object:nil];
    [self setUpMainTable];
    [self startShimmer];
    [self getCatalogRequest];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, -(HX_SCREEN_WIDTH*2/5.f), HX_SCREEN_WIDTH, HX_SCREEN_WIDTH*2/5.f);
}
-(GXActivityBannerHeader *)header
{
    if (_header == nil) {
        _header = [GXActivityBannerHeader loadXibView];
        _header.frame = CGRectMake(0,0, HX_SCREEN_WIDTH, HX_SCREEN_WIDTH*2/5.f);
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
        for (GXCatalogItem *item in self.activityInfo.catalog) {
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
            GXActivityChildVC *cvc = [GXActivityChildVC new];
            GXCatalogItem *item = self.activityInfo.catalog[i];
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
    searchBar.layer.cornerRadius = 6;
    searchBar.layer.masksToBounds = YES;
    searchBar.delegate = self;
    self.searchBar = searchBar;
    self.navigationItem.titleView = searchBar;
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
    
    self.tableView.contentInset = UIEdgeInsetsMake(HX_SCREEN_WIDTH*2/5.f,0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = HXGlobalBg;
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView addSubview:self.header];
}
#pragma mark -- 接口请求
-(void)getCatalogRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/promoteGoods" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.activityInfo = [GXActivityCataInfo yy_modelWithDictionary:responseObject[@"data"]];
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
    self.tableView.hidden = NO;
    
    self.header.adv = self.activityInfo.adv;
    
    hx_weakify(self);
    self.header.activityBannerClicked = ^(NSInteger index) {
        hx_strongify(weakSelf);
        GXActivityBanner *banner = strongSelf.activityInfo.adv[index];
        /** 1仅图片 2链接内容 3html富文本内容 4产品详情 */
        if ([banner.adv_type isEqualToString:@"1"]) {
            HXLog(@"仅图片");
        }else if ([banner.adv_type isEqualToString:@"2"]) {
            GXWebContentVC *cvc = [GXWebContentVC new];
            cvc.navTitle = banner.adv_name;
            cvc.isNeedRequest = NO;
            cvc.url = banner.adv_content;
            [strongSelf.navigationController pushViewController:cvc animated:YES];
        }else if ([banner.adv_type isEqualToString:@"3"]) {
            GXWebContentVC *cvc = [GXWebContentVC new];
            cvc.navTitle = banner.adv_name;
            cvc.isNeedRequest = NO;
            cvc.htmlContent = banner.adv_content;
            [strongSelf.navigationController pushViewController:cvc animated:YES];
        }else{
            GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
            dvc.goods_id = banner.adv_content;
            [strongSelf.navigationController pushViewController:dvc animated:YES];
        }
    };
    
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
#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField hasText]) {
        [textField resignFirstResponder];
        
        GXSearchActivityVC *gvc = [GXSearchActivityVC new];
        gvc.keyword = textField.text;
        [self.navigationController pushViewController:gvc animated:YES];
        return YES;
    }else{
        return NO;
    }
}
#pragma mark -- JXCategoryViewDelegate
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
    return self.activityInfo?1:0;
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
