//
//  GXOrderManageVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/8.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXOrderManageVC.h"
#import "GXOrderManageChildVC.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorLineView.h>
#import "HXSearchBar.h"
#import "GXMessageVC.h"
#import "GXMySetVC.h"
#import "GXMineData.h"
#import "UIView+WZLBadge.h"

@interface GXOrderManageVC ()<JXCategoryViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/** 子控制器数组 */
@property (nonatomic,strong) NSArray *childVCs;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
/* 消息 */
@property(nonatomic,strong) SPButton *msgBtn;
/* 个人信息 */
@property(nonatomic,strong) GXMineData *mineData;
@end

@implementation GXOrderManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCategoryView];
    [self getMemberRequest];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getHomeUnReadMsg];
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
            GXOrderManageChildVC *cvc0 = [GXOrderManageChildVC new];
            cvc0.status = i+1;
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
    
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH - 100.f, 30.f)];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 6;
    searchBar.layer.masksToBounds = YES;
    searchBar.placeholder = @"请输入商品名称查询";
    searchBar.delegate = self;
    self.searchBar = searchBar;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    
    SPButton *msg = [SPButton buttonWithType:UIButtonTypeCustom];
    msg.imagePosition = SPButtonImagePositionTop;
    msg.imageTitleSpace = 2.f;
    msg.hxn_size = CGSizeMake(40, 40);
    msg.titleLabel.font = [UIFont systemFontOfSize:9];
    [msg setImage:HXGetImage(@"消息") forState:UIControlStateNormal];
    [msg setTitle:@"消息" forState:UIControlStateNormal];
    [msg addTarget:self action:@selector(msgClicked) forControlEvents:UIControlEventTouchUpInside];
    [msg setTitleColor:UIColorFromRGB(0XFFFFFF) forState:UIControlStateNormal];
    msg.badgeBgColor = [UIColor whiteColor];
    msg.badgeCenterOffset = CGPointMake(-10, 5);
    self.msgBtn = msg;
    UIBarButtonItem *msgItem = [[UIBarButtonItem alloc] initWithCustomView:msg];
    
    SPButton *set = [SPButton buttonWithType:UIButtonTypeCustom];
    set.imagePosition = SPButtonImagePositionTop;
    set.imageTitleSpace = 2.f;
    set.hxn_size = CGSizeMake(40, 40);
    set.titleLabel.font = [UIFont systemFontOfSize:9];
    [set setImage:HXGetImage(@"管理设置") forState:UIControlStateNormal];
    [set setTitle:@"设置" forState:UIControlStateNormal];
    [set addTarget:self action:@selector(setClicked) forControlEvents:UIControlEventTouchUpInside];
    [set setTitleColor:UIColorFromRGB(0XFFFFFF) forState:UIControlStateNormal];
    UIBarButtonItem *setItem = [[UIBarButtonItem alloc] initWithCustomView:set];

    self.navigationItem.rightBarButtonItems = @[msgItem,setItem];
}
-(void)setUpCategoryView
{
    _categoryView.backgroundColor = [UIColor whiteColor];
    _categoryView.titleLabelZoomEnabled = NO;
    _categoryView.titles = @[@"全部", @"待发货",@"待收货", @"待评价", @"售后退款"];
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    GXOrderManageChildVC *targetViewController = (GXOrderManageChildVC *)self.childVCs[self.categoryView.selectedIndex];
    if ([textField hasText]) {
        targetViewController.seaKey = textField.text;
    }else{
        targetViewController.seaKey = @"";
    }
    return YES;
}
#pragma mark -- 点击事件
-(void)msgClicked
{
    GXMessageVC *mvc = [GXMessageVC new];
    [self.navigationController pushViewController:mvc animated:YES];
}
-(void)setClicked
{
    GXMySetVC *mvc = [GXMySetVC new];
    mvc.mineData = self.mineData;
    [self.navigationController pushViewController:mvc animated:YES];
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
#pragma mark -- 接口
-(void)getMemberRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getMineData" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.mineData = [GXMineData yy_modelWithDictionary:responseObject[@"data"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getHomeUnReadMsg
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getHomeMsg" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if ([responseObject[@"data"] boolValue]) {
                [strongSelf.msgBtn showBadgeWithStyle:WBadgeStyleRedDot value:1 animationType:WBadgeAnimTypeNone];
            }else{
                [strongSelf.msgBtn clearBadge];
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
