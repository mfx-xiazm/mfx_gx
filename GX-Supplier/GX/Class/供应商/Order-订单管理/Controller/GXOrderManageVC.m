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
#import "UIView+WZLBadge.h"
#import "GXGiftGoodsVC.h"
#import "SZUpdateView.h"
#import <zhPopupController.h>

@interface GXOrderManageVC ()<JXCategoryViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/** 子控制器数组 */
@property (nonatomic,strong) NSArray *childVCs;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
/* 消息 */
@property(nonatomic,strong) SPButton *msgBtn;
@end

@implementation GXOrderManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCategoryView];
    [self updateVersionRequest];//版本升级
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
            if ((i+1) == self.categoryView.titles.count) {
                GXGiftGoodsVC *gvc = [GXGiftGoodsVC new];
                [self addChildViewController:gvc];
                [vcs addObject:gvc];
            }else{
                GXOrderManageChildVC *cvc0 = [GXOrderManageChildVC new];
                cvc0.status = i+1;
                [self addChildViewController:cvc0];
                [vcs addObject:cvc0];
            }
        }
        _childVCs = vcs;
    }
    return _childVCs;
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH - 70.f, 30.f)];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 15.f;
    searchBar.layer.masksToBounds = YES;
    searchBar.placeholder = @"请输入商品名称查询";
    searchBar.delegate = self;
    self.searchBar = searchBar;
    self.navigationItem.titleView = searchBar;

    SPButton *msg = [SPButton buttonWithType:UIButtonTypeCustom];
    msg.hxn_size = CGSizeMake(40, 40);
    msg.titleLabel.font = [UIFont systemFontOfSize:9];
    [msg setImage:HXGetImage(@"消息") forState:UIControlStateNormal];
    [msg addTarget:self action:@selector(msgClicked) forControlEvents:UIControlEventTouchUpInside];
    msg.badgeBgColor = [UIColor whiteColor];
    msg.badgeTextColor = HXControlBg;
    msg.badgeCenterOffset = CGPointMake(-12, 8);
    self.msgBtn = msg;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:msg];
}
-(void)setUpCategoryView
{
    _categoryView.backgroundColor = [UIColor whiteColor];
    _categoryView.titleLabelZoomEnabled = NO;
    _categoryView.titles = @[@"全部", @"待发货",@"待收货", @"待评价", @"售后退款", @"赠品订单"];
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
    if (self.categoryView.selectedIndex == 5) {
        GXGiftGoodsVC *targetViewController = (GXGiftGoodsVC *)self.childVCs[self.categoryView.selectedIndex];
        if ([textField hasText]) {
            targetViewController.seaKey = textField.text;
        }else{
            targetViewController.seaKey = @"";
        }
    }else{
        GXOrderManageChildVC *targetViewController = (GXOrderManageChildVC *)self.childVCs[self.categoryView.selectedIndex];
        if ([textField hasText]) {
            targetViewController.seaKey = textField.text;
        }else{
            targetViewController.seaKey = @"";
        }
    }
    return YES;
}
#pragma mark -- 点击事件
-(void)msgClicked
{
    GXMessageVC *mvc = [GXMessageVC new];
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
-(void)getHomeUnReadMsg
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"index/getHomeMsg" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if ([responseObject[@"data"] boolValue]) {
                [strongSelf.msgBtn showBadgeWithStyle:WBadgeStyleNumber value:[responseObject[@"data"] integerValue] animationType:WBadgeAnimTypeNone];
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
-(void)updateVersionRequest
{
    hx_weakify(self);
    NSString *key = @"CFBundleShortVersionString";
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    [HXNetworkTool POST:HXRC_M_URL action:@"index/isNewVersions" parameters:@{@"sys":@"2",@"versions":currentVersion} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] boolValue]) {
            if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                [strongSelf updateAlert:responseObject[@"data"]];
            }
        }else{
            //[JMNotifyView showNotify:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        //[JMNotifyView showNotify:error.localizedDescription];
    }];
}
-(void)updateAlert:(NSDictionary *)dict
{
    // 删除数据
    SZUpdateView *alert = [SZUpdateView loadXibView];
    alert.hxn_width = HX_SCREEN_WIDTH - 30*2;
    alert.hxn_height = (HX_SCREEN_WIDTH - 30*2) *130/300.0 + 240;
    if ([dict[@"must_type"] integerValue] == 1) {
        alert.closeBtn.hidden = YES;
    }else{
        alert.closeBtn.hidden = NO;
    }
    alert.versionTxt.text = [NSString stringWithFormat:@"发现新版本V%@",dict[@"app_version"]];
    alert.updateText.text = dict[@"update_content"];
    hx_weakify(self);
    alert.updateClickedCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        if (index == 1) {// 强制更新不消失
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1521112044?mt=8"]];
        }else{// 不强制更新消失
            [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    [self.zh_popupController presentContentView:nil duration:0.25 springAnimated:NO];
}
@end
