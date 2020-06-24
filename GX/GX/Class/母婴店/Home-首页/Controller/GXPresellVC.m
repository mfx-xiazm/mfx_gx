//
//  GXPresellVC.m
//  GX
//
//  Created by huaxin-01 on 2020/6/17.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXPresellVC.h"
#import "JXPagerView.h"
#import <JXCategoryImageView.h>
#import <JXCategoryIndicatorLineView.h>
#import "GXPresellChildVC.h"
#import "GXPresellHeader.h"

static const CGFloat JXheightForHeaderInSection = 50;
@interface GXPresellVC ()<JXPagerViewDelegate,JXPagerMainTableViewGestureDelegate,JXCategoryViewDelegate>
@property (nonatomic, strong) JXPagerView *pagerView;
@property (nonatomic, strong) GXPresellHeader *headerView;
@property (nonatomic, strong) JXCategoryImageView *categoryView;
@property (nonatomic, strong) UIView *categorySuperView;
@end

@implementation GXPresellVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self.view addSubview:self.pagerView];
    [self.categorySuperView addSubview:self.categoryView];
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
    [self.pagerView reloadData];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.pagerView.frame = CGRectMake(0, 0, self.view.hxn_width, self.view.hxn_height - self.HXButtomHeight);
}
#pragma mark -- 懒加载
-(JXPagerView *)pagerView
{
    if (!_pagerView) {
        _pagerView = [[JXPagerView alloc] initWithDelegate:self];
        _pagerView.mainTableView.gestureDelegate = self;
        _pagerView.mainTableView.bounces = NO;
        _pagerView.pinSectionHeaderVerticalOffset = self.HXNavBarHeight;//调整悬停位置
    }
    return _pagerView;
}
-(JXCategoryImageView *)categoryView
{
    if (!_categoryView) {
        _categoryView = [[JXCategoryImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-240)/2.0, 0, 240, JXheightForHeaderInSection)];
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.imageNames = @[@"预售中灰",@"即将开始灰"];
        _categoryView.selectedImageNames = @[@"预售中",@"即将开始"];
        _categoryView.imageSize = CGSizeMake(80.f, 24.f);
        _categoryView.delegate = self;
        _categoryView.averageCellSpacingEnabled = YES;
        _categoryView.separatorLineShowEnabled = YES;
        _categoryView.contentScrollViewClickTransitionAnimationEnabled = YES;
    }
    return _categoryView;
}
-(UIView *)categorySuperView
{
    if (!_categorySuperView) {
        _categorySuperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JXheightForHeaderInSection)];
        _categorySuperView.backgroundColor = [UIColor whiteColor];
    }
    return _categorySuperView;
}
-(GXPresellHeader *)headerView
{
    if (!_headerView) {
        _headerView = [GXPresellHeader loadXibView];
        _headerView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 300);
    }
    return _headerView;
}
#pragma mark -- 视图
-(void)setUpNavBar
{
    self.hbd_barAlpha = 0.f;
    self.hbd_barTintColor = UIColorFromRGB(0x330077);
    self.hbd_barShadowHidden = YES;
    [self.navigationItem setTitle:@"预售专区"];
}
#pragma mark -- 接口请求

#pragma mark -- 点击事件

#pragma mark -- JXPagerViewDelegate
-(void)mainTableViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat headerHeight = 300.f-self.HXNavBarHeight;
    CGFloat progress = scrollView.contentOffset.y;
    CGFloat gradientProgress = MIN(1, MAX(0, progress  / headerHeight));
    gradientProgress = gradientProgress * gradientProgress * gradientProgress * gradientProgress;
    self.hbd_barAlpha = gradientProgress;
    [self hbd_setNeedsUpdateNavigationBar];
}
/**
 返回tableHeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView
{
    return 300;
}

/**
 返回tableHeaderView
 */
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView
{
    return self.headerView;
}

/**
 返回悬浮HeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView
{
    return JXheightForHeaderInSection;
}

/**
 返回悬浮HeaderView。我用的是自己封装的JXCategoryView
 */
- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView
{
    return self.categorySuperView;
}

/**
 返回列表的数量
 */
- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView
{
    return self.categoryView.imageNames.count;
}

/**
 根据index初始化一个对应列表实例，需要是遵从`JXPagerViewListViewDelegate`协议的对象。
 如果列表是用自定义UIView封装的，就让自定义UIView遵从`JXPagerViewListViewDelegate`协议，该方法返回自定义UIView即可。
 如果列表是用自定义UIViewController封装的，就让自定义UIViewController遵从`JXPagerViewListViewDelegate`协议，该方法返回自定义UIViewController即可。
 注意：一定要是新生成的实例！！！

 @param pagerView pagerView description
 @param index index description
 @return 新生成的列表实例
 */
- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index
{
    GXPresellChildVC *hvc = [GXPresellChildVC new];
    hvc.seaType = index+1;
    return hvc;
}

#pragma mark -- JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    HXLog(@"分类切换");
}

#pragma mark -- JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
-(void)dealloc
{
    HXLog(@"预售销毁");
}
@end
