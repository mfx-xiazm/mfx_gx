//
//  GXApplySupplyVC.m
//  GX
//
//  Created by 夏增明 on 2020/2/7.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXApplySupplyVC.h"
#import "GXChooseAddressView.h"
#import <zhPopupController.h>
#import "GXCatalogItem.h"
#import "GXRegion.h"
#import "GXSelectRegion.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GXRunCategoryCell.h"
#import "GXCatalogItem.h"
#import <WebKit/WebKit.h>
#import "UITextField+GYExpand.h"

static NSString *const RunCategoryCell = @"RunCategoryCell";
@interface GXApplySupplyVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate,WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, weak) IBOutlet UIView *webContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webContentViewHeight;

@property (nonatomic, strong) WKWebView     *webView;
@property (nonatomic, weak) IBOutlet UITextField *name;//名称
@property (nonatomic, weak) IBOutlet UITextField *phone;//手机号
@property (nonatomic, weak) IBOutlet UITextField *area;//地址
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (nonatomic, weak) IBOutlet UIButton *submitBtn;

@property (nonatomic, copy) NSString *catalogs_id;//经营类目 经营类目 多个catalog_id间用逗号隔开
/* 地址 */
@property(nonatomic,strong) GXChooseAddressView *addressView;
/* 省id */
@property(nonatomic,copy) NSString *pro_id;
/* 市id */
@property(nonatomic,copy) NSString *city_id;
/* 区id */
@property(nonatomic,copy) NSString *area_id;
/* 富文本 */
@property(nonatomic,copy) NSString *webHtml;
/* 经营类目 */
@property(nonatomic,strong) NSArray *catalogItem;
/* 所有地区 */
@property(nonatomic,strong) GXSelectRegion *region;
/* 地址选择框 */
@property (nonatomic, strong) zhPopupController *addressPopVC;
@end

@implementation GXApplySupplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"申请供货"];
    [self.webContentView addSubview:self.webView];
    [self setUpCollectionView];
    [self startShimmer];
    [self getAllAreaRequest];
    [self loadWebDataRequest];
    
    hx_weakify(self);
    [self.phone lengthLimit:^{
        hx_strongify(weakSelf);
        if (strongSelf.phone.text.length > 11) {
            strongSelf.phone.text = [strongSelf.phone.text substringToIndex:11];
        }
    }];
    
    [self.submitBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.name hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入姓名"];
            return NO;
        }
        if (![strongSelf.phone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入手机号"];
            return NO;
        }
        if (strongSelf.phone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机号格式有误"];
            return NO;
        }
        if (![strongSelf.area hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择发货地区"];
            return NO;
        }
        NSMutableString *itemids = [NSMutableString string];
        for (GXCatalogItem *item in strongSelf.catalogItem) {
            if (item.isSelected) {
                if (itemids.length) {
                    [itemids appendFormat:@",%@",item.catalog_id];
                }else{
                    [itemids appendFormat:@"%@",item.catalog_id];
                }
            }
        }
        if (!itemids.length) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择供货品类"];
            return NO;
        }
        strongSelf.catalogs_id = itemids;
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf submitClicked:button];
    }];
    
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.webView.frame = self.webContentView.bounds;
}
#pragma mark -- 懒加载
-(GXChooseAddressView *)addressView
{
    if (_addressView == nil) {
        _addressView = [GXChooseAddressView loadXibView];
        _addressView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 360);
        _addressView.componentsNum = 3;
        __weak __typeof(self) weakSelf = self;
        // 最后一列的行被点击的回调
        _addressView.lastComponentClickedBlock = ^(NSInteger type, GXSelectRegion * _Nullable region) {
            [weakSelf.addressPopVC dismissWithDuration:0.25 completion:nil];
            if (type) {
                weakSelf.area.text = [NSString stringWithFormat:@"%@%@%@",region.selectRegion.area_alias,region.selectCity.area_alias,region.selectArea.area_alias];
                weakSelf.pro_id = region.selectRegion.area_id;
                weakSelf.city_id = region.selectCity.area_id;
                weakSelf.area_id = region.selectArea.area_id;
            }
        };
    }
    return _addressView;
}
-(zhPopupController *)addressPopVC
{
    if (!_addressPopVC) {
        _addressPopVC = [[zhPopupController alloc] initWithView:self.addressView size:self.addressView.bounds.size];
        _addressPopVC.layoutType = zhPopupLayoutTypeBottom;
    }
    return _addressPopVC;
}
- (WKWebView *)webView{
    if (_webView == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        //        preference.minimumFontSize = 16;
        //        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        //        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preference;
        
        _webView = [[WKWebView alloc] initWithFrame:self.webContentView.bounds configuration:configuration];
        // UI代理
        _webView.UIDelegate = self;
        // 导航代理
        _webView.navigationDelegate = self;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;
        
        _webView.scrollView.scrollEnabled = NO;
        [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return _webView;
}
-(void)setUpCollectionView
{
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXRunCategoryCell class]) bundle:nil] forCellWithReuseIdentifier:RunCategoryCell];
}
#pragma mark -- 事件监听
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.webView.hxn_height = self.webView.scrollView.contentSize.height;
        self.webContentViewHeight.constant = self.webView.scrollView.contentSize.height;
    }
}
-(void)dealloc
{
    @try {
        [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    }
    @catch (NSException *exception) {
        HXLog(@"多次删除了");
    }
    @finally {
        HXLog(@"多次删除了");
    }
}
#pragma mark -- 业务接口
-(void)loadWebDataRequest
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 执行循序1
    hx_weakify(self);
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        [HXNetworkTool POST:HXRC_M_URL action:@"admin/getSupplyIntroData" parameters:@{} success:^(id responseObject) {
            if([[responseObject objectForKey:@"status"] integerValue] == 1) {
                strongSelf.webHtml = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:15px 15px;}</style></head><body>%@</body></html>",responseObject[@"data"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            dispatch_semaphore_signal(semaphore);
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        }];
    });
    // 执行循序2
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        [HXNetworkTool POST:HXRC_M_URL action:@"admin/getCatalogItem" parameters:@{} success:^(id responseObject) {
            if([[responseObject objectForKey:@"status"] integerValue] == 1) {
                strongSelf.catalogItem = [NSArray yy_modelArrayWithClass:[GXCatalogItem class] json:responseObject[@"data"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            dispatch_semaphore_signal(semaphore);
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        }];
    });

    dispatch_group_notify(group, queue, ^{
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        // 执行顺序8
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新界面
            hx_strongify(weakSelf);
            [strongSelf stopShimmer];
            [strongSelf.webView loadHTMLString:strongSelf.webHtml baseURL:[NSURL URLWithString:HXRC_URL_HEADER]];
            [strongSelf.collectionView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                strongSelf.collectionViewHeight.constant = strongSelf.collectionView.contentSize.height;
            });
        });
    });
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}
-(void)getAllAreaRequest
{
    hx_weakify(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        hx_strongify(weakSelf);
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"areaData" ofType:@"txt"];
        NSString *districtStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
        
        if (districtStr == nil) {
            return ;
        }
        NSData *jsonData = [districtStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        strongSelf.region = [[GXSelectRegion alloc] init];
        strongSelf.region.regions = [NSArray yy_modelArrayWithClass:[GXRegion class] json:responseObject[@"data"]];
    });
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getAreaData" parameters:@{} success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            strongSelf.region = [[GXSelectRegion alloc] init];
//            strongSelf.region.regions = [NSArray yy_modelArrayWithClass:[GXRegion class] json:responseObject[@"data"]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                strongSelf.header.region = strongSelf.region;
//            });
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
}
#pragma mark -- 点击事件
- (IBAction)chooseAdressClicked:(UIButton *)sender {
    if (!self.region || !self.region.regions.count) {
        return;
    }
    self.addressView.region = self.region;
    [self.addressPopVC show];
}
-(void)submitClicked:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"supply_name"] = self.name.text;
    parameters[@"phone"] = self.phone.text;
    parameters[@"province_id"] = self.pro_id;
    parameters[@"city_id"] = self.city_id;
    parameters[@"district_id"] = self.area_id;
    parameters[@"address_detail"] = @"";
    parameters[@"catalogs"] = self.catalogs_id;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/saveSupply" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"提交" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"提交成功"];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"提交" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.catalogItem.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return LabelLayout;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GXRunCategoryCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:RunCategoryCell forIndexPath:indexPath];
    GXCatalogItem *logItem = self.catalogItem[indexPath.item];
    cell.logItem = logItem;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GXCatalogItem *logItem = self.catalogItem[indexPath.item];
    logItem.isSelected = !logItem.isSelected;
    [collectionView reloadData];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    GXCatalogItem *logItem = self.catalogItem[indexPath.item];
    return CGSizeMake([logItem.catalog_name boundingRectWithSize:CGSizeMake(1000000, 34) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 20, 34);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(5, 15, 5, 15);
}
@end
