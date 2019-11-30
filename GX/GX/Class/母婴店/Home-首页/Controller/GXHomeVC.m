//
//  GXHomeVC.m
//  GX
//
//  Created by 夏增明 on 2019/9/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXHomeVC.h"
#import "GXShopGoodsCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GXRunCategoryCell.h"
#import "HXSearchBar.h"
#import "UIView+WZLBadge.h"
#import "GXHomeSectionHeader.h"
#import "GXHomePushCell.h"
#import "GXDiscountGoodsCell.h"
#import "GXDiscountGoodsCell2.h"
#import "GXHomeCateCell.h"
#import "GXHomeSectionBgReusableView.h"
#import "GXHomeSectionBgReusableView2.h"
#import "GXHomeBannerHeader.h"
#import "GXGoodStoreVC.h"
#import "GXGoodsDetailVC.h"
#import "GXGoodBrandVC.h"
#import "GXActivityVC.h"
#import "GXDiscountVC.h"
#import "GXMarketTrendVC.h"
#import "GXSaleMaterialVC.h"
#import "GXRegionalVC.h"
#import "GXBrandPartnerVC.h"
#import "GXBrandDetailVC.h"
#import "GXWebContentVC.h"
#import "GXMessageVC.h"
#import "GXHomeData.h"
#import "GXSearchResultVC.h"
#import "GXActivityContentVC.h"
#import "SZUpdateView.h"
#import <zhPopupController.h>

static NSString *const HomeCateCell = @"HomeCateCell";
static NSString *const ShopGoodsCell = @"ShopGoodsCell";
static NSString *const HomePushCell = @"HomePushCell";
static NSString *const DiscountGoodsCell = @"DiscountGoodsCell";
static NSString *const DiscountGoodsCell2 = @"DiscountGoodsCell2";
static NSString *const HomeSectionHeader = @"HomeSectionHeader";
static NSString *const HomeBannerHeader = @"HomeBannerHeader";

@interface GXHomeVC ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
/* 消息 */
@property(nonatomic,strong) SPButton *msgBtn;
/* 首页数据 */
@property(nonatomic,strong) GXHomeData *homeData;
@end

@implementation GXHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCollectionView];
    [self setUpRefresh];
    [self startShimmer];
    [self getHomeDataRequest];
    [self updateVersionRequest];//版本升级
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getHomeUnReadMsg];
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH - 70.f, 30.f)];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 6;
    searchBar.layer.masksToBounds = YES;
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入商品名称查询";
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:msg];
}
-(void)setUpCollectionView
{
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXHomeCateCell class]) bundle:nil] forCellWithReuseIdentifier:HomeCateCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXShopGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:ShopGoodsCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXDiscountGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:DiscountGoodsCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXDiscountGoodsCell2 class]) bundle:nil] forCellWithReuseIdentifier:DiscountGoodsCell2];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXHomePushCell class]) bundle:nil] forCellWithReuseIdentifier:HomePushCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXHomeSectionHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeSectionHeader];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXHomeBannerHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeBannerHeader];
    
    hx_weakify(self);
    [self.collectionView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
        [weakSelf startShimmer];
        [weakSelf getHomeDataRequest];
    }]; 
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.collectionView.mj_footer resetNoMoreData];
        [strongSelf getHomeDataRequest];
    }];
}
#pragma mark -- 点击事件
-(void)msgClicked
{
    GXMessageVC *mvc = [GXMessageVC new];
    [self.navigationController pushViewController:mvc animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField hasText]) {
        [textField resignFirstResponder];

        GXSearchResultVC *gvc = [GXSearchResultVC new];
        gvc.keyword = textField.text;
        [self.navigationController pushViewController:gvc animated:YES];
        return YES;
    }else{
        return NO;
    }
}
#pragma mark -- 接口请求
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
-(void)getHomeDataRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getHomeData" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [strongSelf.collectionView.mj_header endRefreshing];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.homeData = [GXHomeData yy_modelWithDictionary:responseObject[@"data"]];
            NSArray *tempArr = @[@{@"cate_name":@"精选好店",@"image_name":@"精选好店"},
                                 @{@"cate_name":@"品牌优选",@"image_name":@"品牌优选"},
                                 @{@"cate_name":@"控区控价",@"image_name":@"控区控价"},
                                 @{@"cate_name":@"促销神器",@"image_name":@"促销神器"},
                                 @{@"cate_name":@"卖货素材",@"image_name":@"卖货素材"}
                                 ];
            strongSelf.homeData.homeTopCate = [NSArray yy_modelArrayWithClass:[GYHomeTopCate class] json:tempArr];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.collectionView.hidden = NO;
                [strongSelf.collectionView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [strongSelf.collectionView.mj_header endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)updateVersionRequest
{
    hx_weakify(self);
    NSString *key = @"CFBundleShortVersionString";
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/isNewVersions" parameters:@{@"sys":@"2",@"versions":currentVersion} success:^(id responseObject) {
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
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1468066838?mt=8"]];
        }else{// 不强制更新消失
            [strongSelf.zh_popupController dismiss];
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.dismissOnMaskTouched = NO;
    [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 7;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {//分类
        return self.homeData.homeTopCate.count;
    }else if (section == 1) {//每日必抢
        return self.homeData.home_rushbuy.count;
    }else if (section == 2) {//控区控价
        return self.homeData.home_control_price_brand.count;
    }else if (section == 3) {//通货行情
        return self.homeData.currency_img.count;
    }else if (section == 4) {//品牌优选
        return self.homeData.home_brand_goods.count;
    }else if (section == 5) {//精选活动
        return self.homeData.home_select_material.count;
    }else{//为你推荐
        return self.homeData.home_recommend_goods.count;
    }
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    if (section == 0) {//分类
        return ClosedLayout;//列布局
    }else if (section == 1) {//每日必抢
        return FillLayout;//填充式布局
    }else if (section == 2) {//控区控价
        return ClosedLayout;
    }else if (section == 3) {//通货行情
        return ClosedLayout;
    }else if (section == 4) {//品牌优选
        return ClosedLayout;
    }else if (section == 5) {//精选活动
        return ClosedLayout;
    }else{//为你推荐
        return ClosedLayout;
    }
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    if (section == 0) {//分类
        return 5;
    }else if (section == 1) {//每日必抢
        return 0;//这个区间为填充式布局
    }else if (section == 2) {//控区控价
        return 1;
    }else if (section == 3) {//通货行情
        return 2;
    }else if (section == 4) {//品牌优选
        return 3;
    }else if (section == 5) {//精选活动
        return 3;
    }else{//为你推荐
        return 2;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//分类
        GXHomeCateCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCateCell forIndexPath:indexPath];
        GYHomeTopCate *topCate = self.homeData.homeTopCate[indexPath.item];
        cell.topCate = topCate;
        return cell;
    }else if (indexPath.section == 1) {//每日必抢
        if (indexPath.item) {
            GXDiscountGoodsCell2 * cell = [collectionView dequeueReusableCellWithReuseIdentifier:DiscountGoodsCell2 forIndexPath:indexPath];
            GYHomeDiscount *discount = self.homeData.home_rushbuy[indexPath.item];
            cell.discount = discount;
            return cell;
        }else{
            GXDiscountGoodsCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:DiscountGoodsCell forIndexPath:indexPath];
            GYHomeDiscount *discount = self.homeData.home_rushbuy[indexPath.item];
            cell.discount = discount;
            hx_weakify(self);
            cell.discountClickedCall = ^{
                hx_strongify(weakSelf);
                GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
                dvc.goods_id = discount.goods_id;
                dvc.rushbuy_id = discount.rushbuy_id;
                [strongSelf.navigationController pushViewController:dvc animated:YES];
            };
            return cell;
        }
    }else if (indexPath.section == 2) {//控区控价
        GXHomePushCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePushCell forIndexPath:indexPath];
        GYHomeRegional *regional = self.homeData.home_control_price_brand[indexPath.item];
        cell.regional = regional;
        return cell;
    }else if (indexPath.section == 3) {//通货行情
        GXHomePushCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePushCell forIndexPath:indexPath];
        GYHomeMarketTrend *marketTrend = self.homeData.currency_img[indexPath.item];
        cell.marketTrend = marketTrend;
        return cell;
    }else if (indexPath.section == 4) {//品牌优选
        GXHomePushCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePushCell forIndexPath:indexPath];
        GYHomeBrand *brand = self.homeData.home_brand_goods[indexPath.item];
        cell.brand = brand;
        return cell;
    }else if (indexPath.section == 5) {//精选活动
        GXHomePushCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePushCell forIndexPath:indexPath];
        GYHomeActivity *activity = self.homeData.home_select_material[indexPath.item];
        cell.activity = activity;
        return cell;
    }else{//为你推荐
        GXShopGoodsCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShopGoodsCell forIndexPath:indexPath];
        GYHomePushGoods *goods = self.homeData.home_recommend_goods[indexPath.item];
        cell.goods = goods;
        return cell;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(HX_SCREEN_WIDTH,HX_SCREEN_WIDTH*2/5.0);
    }else{
        if (section == 1) {//每日必抢
            if (self.homeData.home_rushbuy.count) {
                return CGSizeMake(HX_SCREEN_WIDTH, 50.f);
            }else{
                return CGSizeZero;
            }
        }else{
            return CGSizeMake(HX_SCREEN_WIDTH, 50.f);
        }
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        if (indexPath.section == 0) {
            GXHomeBannerHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeBannerHeader forIndexPath:indexPath];
            header.homeAdv = self.homeData.homeAdv;
            hx_weakify(self);
            header.bannerClickCall = ^(NSInteger item) {
                hx_strongify(weakSelf);
                GYHomeBanner *banner = strongSelf.homeData.homeAdv[item];
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
            return header;
        }else{
            GXHomeSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeSectionHeader forIndexPath:indexPath];
            if (indexPath.section == 6) {//为你推荐
                header.recommendView.hidden = NO;
                header.titleView.hidden = YES;
            }else{
                header.recommendView.hidden = YES;
                header.titleView.hidden = NO;
                if (indexPath.section == 1) {//每日必抢
                    header.moreTitle.textColor = [UIColor whiteColor];
                    header.moreImg.image = HXGetImage(@"更多");
                    header.titleImg.image = HXGetImage(@"每日必抢");
                }else if (indexPath.section == 2) {//控区控价
                    header.moreTitle.textColor = [UIColor lightGrayColor];
                    header.moreImg.image = HXGetImage(@"更多灰色");
                    header.titleImg.image = HXGetImage(@"控区控价_1");
                }else if (indexPath.section == 3) {//通货行情
                    header.moreTitle.textColor = [UIColor lightGrayColor];
                    header.moreImg.image = HXGetImage(@"更多灰色");
                    header.titleImg.image = HXGetImage(@"通货行情");
                }else if (indexPath.section == 4) {//品牌优选
                    header.moreTitle.textColor = [UIColor lightGrayColor];
                    header.moreImg.image = HXGetImage(@"更多灰色");
                    header.titleImg.image = HXGetImage(@"品牌优选_1");
                }else if (indexPath.section == 5) {//精选活动
                    header.moreTitle.textColor = [UIColor lightGrayColor];
                    header.moreImg.image = HXGetImage(@"更多灰色");
                    header.titleImg.image = HXGetImage(@"精选活动");
                }
                hx_weakify(self);
                header.moreBtnClickedCall = ^{
                    hx_strongify(weakSelf);
                    if (indexPath.section == 1) {//每日必抢
                        GXDiscountVC *dvc = [GXDiscountVC new];
                        [strongSelf.navigationController pushViewController:dvc animated:YES];
                    }else if (indexPath.section == 2) {//控区控价
                        GXBrandPartnerVC *pvc = [GXBrandPartnerVC new];
                        [strongSelf.navigationController pushViewController:pvc animated:YES];
                    }else if (indexPath.section == 3) {//通货行情
                        GXMarketTrendVC *tvc = [GXMarketTrendVC new];
                        GYHomeMarketTrend *trend = strongSelf.homeData.currency_img.firstObject;
                        tvc.left_trend_img = trend.trade_img;
                        GYHomeMarketTrend *trend1 = strongSelf.homeData.currency_img.lastObject;
                        tvc.right_trend_img = trend1.trade_img;
                        tvc.selectIndex = 0;
                        [strongSelf.navigationController pushViewController:tvc animated:YES];
                    }else if (indexPath.section == 4) {//品牌优选
                        GXGoodBrandVC *bvc = [GXGoodBrandVC new];
                        [strongSelf.navigationController pushViewController:bvc animated:YES];
                    }else if (indexPath.section == 5) {//精选活动
                        GXActivityVC *avc = [GXActivityVC new];
                        [strongSelf.navigationController pushViewController:avc animated:YES];
                    }
                };
            }
            if (indexPath.section == 1) {//每日必抢
                return self.homeData.home_rushbuy.count?header:nil;
            }else{
                return header;
            }
        }
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//分类
        if (indexPath.item == 0) {
            GXGoodStoreVC *svc = [GXGoodStoreVC new];
            [self.navigationController pushViewController:svc animated:YES];
        }else if (indexPath.item == 1) {
            GXGoodBrandVC *bvc = [GXGoodBrandVC new];
            [self.navigationController pushViewController:bvc animated:YES];
        }else if (indexPath.item == 2) {
            GXRegionalVC *rvc = [GXRegionalVC new];
            [self.navigationController pushViewController:rvc animated:YES];
        }else if (indexPath.item == 3) {
            GXActivityVC *avc = [GXActivityVC new];
            [self.navigationController pushViewController:avc animated:YES];
        }else{
            GXSaleMaterialVC *mvc = [GXSaleMaterialVC new];
            [self.navigationController pushViewController:mvc animated:YES];
        }
    }else if (indexPath.section == 1) {//每日必抢,这个区间为填充式布局
        GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
        GYHomeDiscount *discount = self.homeData.home_rushbuy[indexPath.item];
        dvc.goods_id = discount.goods_id;
        dvc.rushbuy_id = discount.rushbuy_id;
        [self.navigationController pushViewController:dvc animated:YES];
    }else if (indexPath.section == 2) {//控区控价
        GXBrandDetailVC *dvc = [GXBrandDetailVC new];
        GYHomeRegional *regional = self.homeData.home_control_price_brand[indexPath.item];
        dvc.brand_id = regional.ref_id;
        [self.navigationController pushViewController:dvc animated:YES];
    }else if (indexPath.section == 3) {//通货行情
        GXMarketTrendVC *tvc = [GXMarketTrendVC new];
        GYHomeMarketTrend *trend = self.homeData.currency_img.firstObject;
        tvc.left_trend_img = trend.trade_img;
        GYHomeMarketTrend *trend1 = self.homeData.currency_img.lastObject;
        tvc.right_trend_img = trend1.trade_img;
        tvc.selectIndex = indexPath.item;
        [self.navigationController pushViewController:tvc animated:YES];
    }else if (indexPath.section == 4) {//品牌优选
        GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
        GYHomeBrand *brand = self.homeData.home_brand_goods[indexPath.item];
        dvc.goods_id = brand.ref_id;
        [self.navigationController pushViewController:dvc animated:YES];
    }else if (indexPath.section == 5) {//精选活动
        GXActivityContentVC *wvc = [GXActivityContentVC new];
        GYHomeActivity *activity = self.homeData.home_select_material[indexPath.item];
        wvc.material_id = activity.ref_id;
        [self.navigationController pushViewController:wvc animated:YES];
    }else{//为你推荐
        GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
        GYHomePushGoods *goods = self.homeData.home_recommend_goods[indexPath.item];
        dvc.goods_id = goods.goods_id;
        [self.navigationController pushViewController:dvc animated:YES];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//分类
        CGFloat width = (HX_SCREEN_WIDTH-10*2.0-15*4.0)/5.0;
        CGFloat height = width+30.f;
        return CGSizeMake(width, height);
    }else if (indexPath.section == 1) {//每日必抢,这个区间为填充式布局
        if (indexPath.item) {
            CGFloat width = (HX_SCREEN_WIDTH-20.f*2.f)/4.0;
            CGFloat height = width+40.f;
            return CGSizeMake(width, height);
        }else{
            CGFloat width = HX_SCREEN_WIDTH-20*2.0;
            CGFloat height = 120.f;
            return CGSizeMake(width, height);
        }
    }else if (indexPath.section == 2) {//控区控价
        CGFloat width = HX_SCREEN_WIDTH-20*2.0;
        CGFloat height = 100.f;
        return CGSizeMake(width, height);
    }else if (indexPath.section == 3) {//通货行情
        CGFloat width = (HX_SCREEN_WIDTH-20*2.0-10.0)/2.0;
        CGFloat height = width;
        return CGSizeMake(width, height);
    }else if (indexPath.section == 4) {//品牌优选
        CGFloat width = (HX_SCREEN_WIDTH-20*2.0-10*2.0)/3.0;
        CGFloat height = width;
        return CGSizeMake(width, height);
    }else if (indexPath.section == 5) {//精选活动
        CGFloat width = (HX_SCREEN_WIDTH-20*2.0-10*2.0)/3.0;
        CGFloat height = width;
        return CGSizeMake(width, height);
    }else{//为你推荐
        CGFloat width = (HX_SCREEN_WIDTH-10*3)/2.0;
        CGFloat height = width+70.f;
        return CGSizeMake(width, height);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {//分类
        return 0.f;
    }else if (section == 1) {//每日必抢
        return 0.f;//这个区间为填充式布局
    }else if (section == 2) {//控区控价
        return 10.f;
    }else if (section == 3) {//通货行情
        return 0.f;
    }else if (section == 4) {//品牌优选
        return 0.f;
    }else if (section == 5) {//精选活动
        return 0.f;
    }else{//为你推荐
        return 5.f;
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {//分类
        return 15.f;
    }else if (section == 1) {//每日必抢
        return 0.f;//这个区间为填充式布局
    }else if (section == 2) {//控区控价
        return 0.f;
    }else if (section == 3) {//通货行情
        return 10.f;
    }else if (section == 4) {//品牌优选
        return 10.f;
    }else if (section == 5) {//精选活动
        return 10.f;
    }else{//为你推荐
        return 5.f;
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {//分类
        return  UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
    }else if (section == 1) {//每日必抢
        return  UIEdgeInsetsMake(0.f, 20.f, 10, 20.f);//这个区间为填充式布局
    }else if (section == 2) {//控区控价
        return  UIEdgeInsetsMake(10.f, 20.f, 10.f, 20.f);
    }else if (section == 3) {//通货行情
        return  UIEdgeInsetsMake(10.f, 20.f, 10.f, 20.f);
    }else if (section == 4) {//品牌优选
        return  UIEdgeInsetsMake(10.f, 20.f, 10.f, 20.f);
    }else if (section == 5) {//精选活动
        return  UIEdgeInsetsMake(10.f, 20.f, 10.f, 20.f);
    }else{//为你推荐
        return  UIEdgeInsetsMake(0.f, 5.f, 15.f, 5.f);
    }
}
- (NSString*)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout registerBackView:(NSInteger)section {
    if (section == 0 || section == 6) {
        return @"";
    }else if (section == 1){
        return self.homeData.home_rushbuy.count?@"GXHomeSectionBgReusableView2":@"";
    }else{
        return @"GXHomeSectionBgReusableView";
    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout attachToTop:(NSInteger)section {
    return YES;
}
@end
