//
//  GXRenewMarketTrendVC.m
//  GX
//
//  Created by huaxin-01 on 2020/6/17.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXRenewMarketTrendVC.h"
#import "GXPageMainTable.h"
#import "GXRenewMarketTrendHeader.h"
#import <JXCategoryView.h>
#import "GXRenewMarketTrendChildVC.h"

static const CGFloat GXheightForHeaderInSection = 220.f;
@interface GXRenewMarketTrendVC ()<UITableViewDelegate,UITableViewDataSource,JXCategoryViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topNavView;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topNavViewHeight;
@property (weak, nonatomic) IBOutlet GXPageMainTable *tableView;
/* 头视图 */
@property(nonatomic,strong) GXRenewMarketTrendHeader *header;
/** 子控制器承载scr */
@property (nonatomic,strong) UIScrollView *scrollView;
/** 子控制器数组 */
@property (nonatomic,strong) NSArray *childVCs;
/** 是否可以滑动 */
@property(nonatomic,assign)BOOL isCanScroll;
/** 切换控制器 */
@property (strong, nonatomic) JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *navCategoryView;

@end

@implementation GXRenewMarketTrendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    self.isCanScroll = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MainTableScroll:) name:@"MainTableScroll" object:nil];
    [self setUpMainTable];
    [self setUpNavCategoryTitleView];
    [self.view addSubview:self.categoryView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, -GXheightForHeaderInSection, HX_SCREEN_WIDTH, GXheightForHeaderInSection);
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(GXRenewMarketTrendHeader *)header
{
    if (_header == nil) {
        _header = [GXRenewMarketTrendHeader loadXibView];
        _header.frame = CGRectMake(0,0, HX_SCREEN_WIDTH, GXheightForHeaderInSection);
    }
    return _header;
}
-(JXCategoryTitleView *)categoryView
{
    if (_categoryView == nil) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.frame = CGRectMake(0, self.HXNavBarHeight, HX_SCREEN_WIDTH, 44);
        _categoryView.backgroundColor = [UIColor clearColor];
        _categoryView.titles = @[@"奶粉", @"纸尿裤"];
        _categoryView.titleFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _categoryView.titleColor = [UIColor whiteColor];
        _categoryView.titleSelectedColor = [UIColor whiteColor];
        _categoryView.defaultSelectedIndex = self.selectIndex;
        _categoryView.delegate = self;
        _categoryView.contentScrollView = self.scrollView;
        
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.verticalMargin = 5.f;
        lineView.indicatorColor = [UIColor whiteColor];
        _categoryView.indicators = @[lineView];
    }
    return _categoryView;
}
-(NSArray *)childVCs
{
    if (_childVCs == nil) {
        NSMutableArray *vcs = [NSMutableArray array];
        
        for (int i=0; i<self.categoryView.titles.count; i++) {
            GXRenewMarketTrendChildVC *cvc = [GXRenewMarketTrendChildVC new];
            cvc.dataType = i+1;
            cvc.mainScrollView = self.tableView;
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
        _scrollView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, HX_SCREEN_HEIGHT-self.HXNavBarHeight-self.HXButtomHeight);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(HX_SCREEN_WIDTH*self.childVCs.count, 0);
        _scrollView.bounces = NO;
        // 加第一个视图
        UIViewController *targetViewController = self.childVCs[self.selectIndex];
        targetViewController.view.frame = CGRectMake(self.selectIndex*HX_SCREEN_WIDTH, 0, HX_SCREEN_WIDTH, _scrollView.hxn_height);
        [_scrollView addSubview:targetViewController.view];
    }
    return  _scrollView;
}
-(void)setUpNavBar
{
    self.topNavView.alpha = 0;
    self.topNavView.backgroundColor = UIColorFromRGB(0xf82e41);;
    self.topNavViewHeight.constant = self.HXNavBarHeight;
}
-(void)setUpMainTable
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.rowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(GXheightForHeaderInSection,0, 0, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = HXGlobalBg;
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView addSubview:self.header];
}
-(void)setUpNavCategoryTitleView
{
    _navCategoryView.backgroundColor = [UIColor clearColor];
    _navCategoryView.titles = @[@"奶粉", @"纸尿裤"];
    _navCategoryView.titleFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _navCategoryView.titleColor = [UIColor whiteColor];
    _navCategoryView.titleSelectedColor = [UIColor whiteColor];
    _navCategoryView.delegate = self;
    _navCategoryView.defaultSelectedIndex = self.selectIndex;
    _navCategoryView.contentScrollView = self.scrollView;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.verticalMargin = 5.f;
    lineView.indicatorColor = [UIColor whiteColor];
    _navCategoryView.indicators = @[lineView];
}
#pragma mark -- 点击事件
- (IBAction)backClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 主视图滑动通知处理
-(void)MainTableScroll:(NSNotification *)user{
    self.isCanScroll = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        CGFloat tabOffsetY = [self.tableView rectForSection:0].origin.y;
        CGFloat offsetY = scrollView.contentOffset.y+self.HXNavBarHeight;
        if (offsetY>=tabOffsetY) {//主视图滑动距离超过头部视图高度
            self.isCanScroll = NO;
            scrollView.contentOffset = CGPointMake(0, -self.HXNavBarHeight);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"childScrollCan" object:nil];
        }else{
            if (!self.isCanScroll) {
                [scrollView setContentOffset:CGPointZero];
            }
        }
//        HXLog(@"便宜%.2f - 打印%.2f",scrollView.contentOffset.y,tabOffsetY);
        CGFloat pointY = scrollView.contentOffset.y+GXheightForHeaderInSection;
        CGRect frame = self.header.imageViewFrame;
        frame.size.height -= pointY;
        frame.origin.y = pointY;
        self.header.imageView.frame = frame;
        
        CGFloat headerHeight = GXheightForHeaderInSection - self.HXNavBarHeight;
        CGFloat progress = pointY;
        CGFloat gradientProgress = MIN(1, MAX(0, progress  / headerHeight));
        self.topNavView.alpha = gradientProgress;
        
        self.navTitle.alpha = 1-gradientProgress;
        
        self.categoryView.hxn_y = self.HXNavBarHeight-pointY;
        self.categoryView.alpha = 1-gradientProgress*3;
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -- JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index
{
    if (categoryView == self.categoryView) {
        [self.navCategoryView selectItemAtIndex:index];
    }else{
        [self.categoryView selectItemAtIndex:index];
    }
}
// 滚动和点击选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    if (index) {
        self.topNavView.backgroundColor = UIColorFromRGB(0x4230f2);
    }else{
        self.topNavView.backgroundColor = UIColorFromRGB(0xf82e41);
    }
    
    self.header.imageView.image = index?HXGetImage(@"行情-纸尿裤"):HXGetImage(@"行情-奶粉");
    self.header.topImg.image = index?HXGetImage(@"顶部图蓝色"):HXGetImage(@"顶部图");
    
    if (self.childVCs.count <= index) {return;}
    
    UIViewController *targetViewController = self.childVCs[index];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(HX_SCREEN_WIDTH * index, 0, HX_SCREEN_WIDTH, self.scrollView.hxn_height);
    
    [self.scrollView addSubview:targetViewController.view];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.scrollView.hxn_height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 添加pageView
    [cell.contentView addSubview:self.scrollView];
    
    return cell;
}

@end
