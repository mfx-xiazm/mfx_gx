//
//  GXSalerOrderManageVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXSalerOrderManageVC.h"
#import "GXSalerOrderManageChildVC.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorLineView.h>
#import "HXSearchBar.h"

@interface GXSalerOrderManageVC ()<JXCategoryViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/** 子控制器数组 */
@property (nonatomic,strong) NSArray *childVCs;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
/* 消息 */
@property(nonatomic,strong) SPButton *msgBtn;
@end

@implementation GXSalerOrderManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCategoryView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
    //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(NSArray *)childVCs
{
    if (_childVCs == nil) {
        NSMutableArray *vcs = [NSMutableArray array];
        for (int i=0;i<self.categoryView.titles.count;i++) {
            GXSalerOrderManageChildVC *cvc0 = [GXSalerOrderManageChildVC new];
            cvc0.dataType = i+1;
            [self addChildViewController:cvc0];
            [vcs addObject:cvc0];
        }
        _childVCs = vcs;
    }
    return _childVCs;
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
        
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH - 88.f, 30.f)];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 15.f;
    searchBar.layer.masksToBounds = YES;
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入店名/商品名称/订单编号";
    self.searchBar = searchBar;
    self.navigationItem.titleView = searchBar;
    
    SPButton *filter = [SPButton buttonWithType:UIButtonTypeCustom];
    filter.hxn_size = CGSizeMake(40, 40);
    filter.titleLabel.font = [UIFont systemFontOfSize:9];
    [filter setImage:HXGetImage(@"时间筛选") forState:UIControlStateNormal];
    [filter addTarget:self action:@selector(filterClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filter];
}
-(void)setUpCategoryView
{
    _categoryView.backgroundColor = [UIColor whiteColor];
    _categoryView.titleLabelZoomEnabled = NO;
    _categoryView.titles = @[@"终端店", @"供应商"];
    _categoryView.titleFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _categoryView.titleColor = [UIColor blackColor];
    _categoryView.titleSelectedColor = HXControlBg;
    _categoryView.delegate = self;
    _categoryView.contentScrollView = self.scrollView;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.verticalMargin = 5.f;
    lineView.indicatorColor = HXControlBg;
    _categoryView.indicators = @[lineView];
    
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(HX_SCREEN_WIDTH*self.childVCs.count, 0);
    
    // 加第一个视图
    UIViewController *targetViewController = self.childVCs.firstObject;
    targetViewController.view.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, _scrollView.hxn_height);
    [_scrollView addSubview:targetViewController.view];
}
#pragma mark -- 点击事件
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    GXSalerOrderManageChildVC *targetViewController = (GXSalerOrderManageChildVC *)self.childVCs[self.categoryView.selectedIndex];
    if ([textField hasText]) {
        targetViewController.seaKey = textField.text;
    }else{
        targetViewController.seaKey = @"";
    }
    return YES;
}
-(void)filterClicked
{
    HXLog(@"筛选");
}
#pragma mark -- JXCategoryViewDelegate
// 滚动和点击选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    // 处理侧滑手势
    //self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    
    if (self.childVCs.count <= index) {return;}
    
    UIViewController *targetViewController = self.childVCs[index];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(HX_SCREEN_WIDTH * index, 0, HX_SCREEN_WIDTH, self.scrollView.hxn_height);
    
    [self.scrollView addSubview:targetViewController.view];
}
@end
