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
#import "ZJPickerView.h"

@interface GXSalerOrderManageVC ()<JXCategoryViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/** 子控制器数组 */
@property (nonatomic,strong) NSArray *childVCs;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
/* 消息 */
@property(nonatomic,strong) SPButton *msgBtn;
/* 订单筛选状态 */
@property (nonatomic, copy) NSString *status;
@end

@implementation GXSalerOrderManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCategoryView];
    [self getOrderNum];
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
-(void)setStatus:(NSString *)status
{
    if (![_status isEqualToString:status]) {
        _status = status;
        GXSalerOrderManageChildVC *mvc = (GXSalerOrderManageChildVC *)self.childVCs.firstObject;
        mvc.status = status;
        
        GXSalerOrderManageChildVC *mvc1 = (GXSalerOrderManageChildVC *)self.childVCs.lastObject;
        mvc1.status = status;
        
        [self getOrderNum];
    }
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
    [self getOrderNum];
    return YES;
}
-(void)filterClicked
{    
    // 1.Custom propery（自定义属性）
    NSDictionary *propertyDict = @{
        ZJPickerViewPropertyCanceBtnTitleKey : @"取消",
        ZJPickerViewPropertySureBtnTitleKey  : @"确定",
        ZJPickerViewPropertyTipLabelTextKey  : (self.status && self.status.length)?self.status:@"订单状态", // 提示内容
        ZJPickerViewPropertyCanceBtnTitleColorKey : UIColorFromRGB(0x999999),
        ZJPickerViewPropertySureBtnTitleColorKey : HXControlBg,
        ZJPickerViewPropertyTipLabelTextColorKey :
            UIColorFromRGB(0x131D2D),
        ZJPickerViewPropertyLineViewBackgroundColorKey : UIColorFromRGB(0xF2F2F2),
        ZJPickerViewPropertyCanceBtnTitleFontKey : [UIFont systemFontOfSize:13.0f],
        ZJPickerViewPropertySureBtnTitleFontKey : [UIFont systemFontOfSize:13.0f],
        ZJPickerViewPropertyTipLabelTextFontKey : [UIFont systemFontOfSize:13.0f],
        ZJPickerViewPropertyPickerViewHeightKey : @260.0f,
        ZJPickerViewPropertyOneComponentRowHeightKey : @40.0f,
        ZJPickerViewPropertySelectRowTitleAttrKey : @{NSForegroundColorAttributeName : HXControlBg, NSFontAttributeName : [UIFont systemFontOfSize:15.0f]},
        ZJPickerViewPropertyUnSelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0x999999), NSFontAttributeName : [UIFont systemFontOfSize:15.0f]},
        ZJPickerViewPropertySelectRowLineBackgroundColorKey : UIColorFromRGB(0xF2F2F2),
        ZJPickerViewPropertyIsTouchBackgroundHideKey : @YES,
        ZJPickerViewPropertyIsShowSelectContentKey : @YES,
        ZJPickerViewPropertyIsScrollToSelectedRowKey: @YES,
        ZJPickerViewPropertyIsAnimationShowKey : @YES};
    
    // 2.Show（显示）
    hx_weakify(self);
    [ZJPickerView zj_showWithDataList:@[@"全部",@"待发货",@"待收货",@"待评价",@"已完成"] propertyDict:propertyDict completion:^(NSString *selectContent) {
        hx_strongify(weakSelf);
        NSArray *results = [selectContent componentsSeparatedByString:@"|"];
        if ([results.firstObject isEqualToString:@"全部"]) {
            strongSelf.status = @"";
        }else{
            strongSelf.status = results.firstObject;
        }
    }];
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
#pragma mark -- 接口
-(void)getOrderNum
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"seaKey"] = [self.searchBar hasText]?self.searchBar.text:@"";
    parameters[@"status"] = (self.status && self.status.length)?self.status:@"";
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"program/getOrderNum" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.categoryView.titles = @[[NSString stringWithFormat:@"终端店(%@)",responseObject[@"data"][@"shopNum"]], [NSString stringWithFormat:@"供应商(%@)",responseObject[@"data"][@"providerNum"]]];
                [strongSelf.categoryView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
