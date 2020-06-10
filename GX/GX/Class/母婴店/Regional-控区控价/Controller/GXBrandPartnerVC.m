//
//  GXBrandPartnerVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXBrandPartnerVC.h"
#import "GXBrandPartnerChildVC.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorLineView.h>
#import "GXGoodsFilterView.h"
#import <zhPopupController.h>
#import "GXCatalogItem.h"

@interface GXBrandPartnerVC ()<JXCategoryViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/* 筛选按钮 */
@property(nonatomic,strong) SPButton *filterBtn;
/** 子控制器数组 */
@property (nonatomic,strong) NSArray *childVCs;
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
    [self setUpCategoryView];
    [self getCatalogItemRequest];
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
            GXBrandPartnerChildVC *cvc0 = [GXBrandPartnerChildVC new];
            cvc0.dataType = i+1;
            [self addChildViewController:cvc0];
            [vcs addObject:cvc0];
        }
        _childVCs = vcs;
    }
    return _childVCs;
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
    [filter setTitle:@"筛选" forState:UIControlStateNormal];
    [filter addTarget:self action:@selector(filterClicked) forControlEvents:UIControlEventTouchUpInside];
    [filter setTitleColor:UIColorFromRGB(0XFFFFFF) forState:UIControlStateNormal];
    self.filterBtn = filter;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filter];
    self.filterBtn.hidden = YES;
}
-(void)setUpCategoryView
{
    _categoryView.backgroundColor = [UIColor whiteColor];
    _categoryView.titleLabelZoomEnabled = NO;
    _categoryView.titles = @[@"已加盟", @"所有品牌"];
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
#pragma mark -- 获取分类
-(void)getCatalogItemRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getCatalogItem" parameters:@{} success:^(id responseObject) {
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
#pragma mark -- JXCategoryViewDelegate
// 滚动和点击选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    // 处理侧滑手势
    //self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    if (index) {
        self.filterBtn.hidden = NO;
    }else{
        self.filterBtn.hidden = YES;
    }
    
    if (self.childVCs.count <= index) {return;}
    
    UIViewController *targetViewController = self.childVCs[index];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(HX_SCREEN_WIDTH * index, 0, HX_SCREEN_WIDTH, self.scrollView.hxn_height);
    
    [self.scrollView addSubview:targetViewController.view];
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
        GXBrandPartnerChildVC *brandVc = (GXBrandPartnerChildVC *)strongSelf.childVCs.lastObject;
        brandVc.catalog_id = cata_id;
    };
    
    self.fliterPopVC = [[zhPopupController alloc] initWithView:self.fliterView size:self.fliterView.bounds.size];
    self.fliterPopVC.layoutType = zhPopupLayoutTypeRight;
    [self.fliterPopVC show];
}
@end
