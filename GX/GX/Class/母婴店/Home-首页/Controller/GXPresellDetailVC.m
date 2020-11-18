//
//  GXPresellDetailVC.m
//  GX
//
//  Created by huaxin-01 on 2020/6/17.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXPresellDetailVC.h"
#import "GXGoodsMaterialCell.h"
#import "GXGoodsMaterialLayout.h"
#import "GXGoodsCommentLayout.h"
#import "GXGoodsCommentCell.h"
#import "GXAllMaterialVC.h"
#import "GXAllCommentVC.h"
#import "GXGoodsDetailSectionHeader.h"
#import "GXGoodsInfoCell.h"
#import "GXWebContentVC.h"
#import <WebKit/WebKit.h>
#import "GXChooseClassView.h"
#import <zhPopupController.h>
#import "GXSankPriceVC.h"
#import "GXBrandDetailVC.h"
#import "GXGoodsDetail.h"
#import "GXCartVC.h"
#import "GXSaleMaterialVC.h"
#import "GXUpOrderVC.h"
#import "GXSaveImageToPHAsset.h"
#import "GXShareView.h"
#import "GXApplySupplyVC.h"
#import <ZLPhotoActionSheet.h>
#import <UMShare/UMShare.h>
#import "GXHomePushCell.h"
#import "XTimer.h"
#import "GXShopGoodsCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GXHomeSectionHeader.h"
#import "GXGoodsGiftCell.h"
#import "GXRebateView.h"
#import "GXFullGiftView.h"
#import "zhAlertView.h"
#import "XQCarousel.h"
#import "GXGoodsDetailVC.h"
#import "GXShareCodeView.h"

static NSString *const HomeSectionHeader = @"HomeSectionHeader";
static NSString *const ShopGoodsCell = @"ShopGoodsCell";
static NSString *const GoodsInfoCell = @"GoodsInfoCell";
static NSString *const GoodsGiftCell = @"GoodsGiftCell";
@interface GXPresellDetailVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,GXGoodsMaterialCellDelegate,GXGoodsCommentCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate,XQCarouselDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIView *cyclePagerView;
@property (weak, nonatomic) IBOutlet UILabel *shop_name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *market_price;
@property (weak, nonatomic) IBOutlet UILabel *cale_num;
@property (weak, nonatomic) IBOutlet UILabel *notice;
@property (weak, nonatomic) IBOutlet UILabel *rush_price;
@property (weak, nonatomic) IBOutlet UILabel *rush_time;
/** 倒计时 */
@property (nonatomic,strong) XTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *rushView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rushViewHeight;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeViewButtom;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UIView *webContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webContentViewHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet UIView *normal_tool;
@property (weak, nonatomic) IBOutlet UIButton *normal_buy_btn;
@property (weak, nonatomic) IBOutlet UIButton *normal_add_btn;
@property (weak, nonatomic) IBOutlet UIView *apply_tool;
@property (weak, nonatomic) IBOutlet UIView *rush_tool;
@property (weak, nonatomic) IBOutlet UILabel *buttom_rush_time;
@property (weak, nonatomic) IBOutlet SPButton *normal_collect;
@property (weak, nonatomic) IBOutlet SPButton *normal_customer_btn;

/* 卖货素材 */
@property(nonatomic,weak) UIButton *materialBtn;
/* 我要供货 */
@property(nonatomic,weak) UIButton *applyBtn;
/* 规格视图 */
@property(nonatomic,strong) GXChooseClassView *chooseClassView;
/* 详情 */
@property(nonatomic,strong) WKWebView *webView;
/* 商品详情 */
@property(nonatomic,strong) GXGoodsDetail *goodsDetail;
/** 分享数据模型 */
@property (nonatomic,strong) GXGoodsMaterialLayout *shareModel;
/** 规格弹框  */
@property (nonatomic, strong) zhPopupController *classPopVC;
/* 分享弹框 */
@property (nonatomic, strong) zhPopupController *sharePopVC;
/* 轮播 */
@property (nonatomic, strong) XQCarousel *carousel;
@end

@implementation GXPresellDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    self.contentScrollView.hidden = YES;
    [self setUpTableView];
    [self setUpCollectionView];
    [self startShimmer];
    [self getGoodDetailRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.materialBtn.layer.cornerRadius = self.materialBtn.hxn_height/2.0;
    self.applyBtn.layer.cornerRadius = self.applyBtn.hxn_height/2.0;
    self.webView.frame = self.webContentView.bounds;
}
-(XQCarousel *)carousel
{
    if (!_carousel) {
        NSMutableArray *bannerImgs = [NSMutableArray array];
        for (GXGoodsDetailAdv *adv in self.goodsDetail.good_adv) {
            [bannerImgs addObject:adv.adv_img];
        }
        _carousel = [XQCarousel scrollViewFrame:self.cyclePagerView.bounds imageStringGroup:bannerImgs];
        _carousel.delegate = self;
    }
    return _carousel;
}
-(GXChooseClassView *)chooseClassView
{
    if (_chooseClassView == nil) {
        _chooseClassView = [GXChooseClassView loadXibView];
        _chooseClassView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 560);
    }
    return _chooseClassView;
}
-(WKWebView *)webView
{
    if (_webView == nil) {
        _webView = [[WKWebView alloc] init];
        _webView.scrollView.scrollEnabled = NO;
        [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [self.webContentView addSubview:_webView];
    }
    return _webView;
}
-(zhPopupController *)classPopVC
{
    if (!_classPopVC) {
        _classPopVC = [[zhPopupController alloc] initWithView:self.chooseClassView size:self.chooseClassView.bounds.size];
        _classPopVC.layoutType = zhPopupLayoutTypeBottom;
        _classPopVC.keyboardChangeFollowed = YES;
    }
    return _classPopVC;
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    UIButton *cart = [UIButton buttonWithType:UIButtonTypeCustom];
    cart.hxn_size = CGSizeMake(40, 40);
    [cart setImage:HXGetImage(@"购物车白") forState:UIControlStateNormal];
    [cart addTarget:self action:@selector(cartClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cartItem = [[UIBarButtonItem alloc] initWithCustomView:cart];

    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.hxn_size = CGSizeMake(40, 40);
    [share setImage:HXGetImage(@"分享白色") forState:UIControlStateNormal];
    [share addTarget:self action:@selector(shareClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:share];
    
    UIButton *material = [UIButton buttonWithType:UIButtonTypeCustom];
    [material setTitle:@"卖货素材" forState:UIControlStateNormal];
    [material setTitleColor:HXControlBg forState:UIControlStateNormal];
    material.titleLabel.font = [UIFont systemFontOfSize:12];
    material.hxn_size = CGSizeMake(70, 22);
    material.layer.cornerRadius = material.hxn_height/2.0;
    material.layer.masksToBounds = YES;
    material.backgroundColor = [UIColor whiteColor];
    [material addTarget:self action:@selector(materialClicked) forControlEvents:UIControlEventTouchUpInside];
    self.materialBtn = material;
    UIBarButtonItem *materialItem = [[UIBarButtonItem alloc] initWithCustomView:material];
    
    UIButton *apply = [UIButton buttonWithType:UIButtonTypeCustom];
    [apply setTitle:@"我要供货" forState:UIControlStateNormal];
    [apply setTitleColor:HXControlBg forState:UIControlStateNormal];
    apply.titleLabel.font = [UIFont systemFontOfSize:12];
    apply.hxn_size = CGSizeMake(70, 22);
    apply.layer.cornerRadius = apply.hxn_height/2.0;
    apply.layer.masksToBounds = YES;
    apply.backgroundColor = [UIColor whiteColor];
    self.applyBtn = apply;
    [apply addTarget:self action:@selector(applyClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *applyItem = [[UIBarButtonItem alloc] initWithCustomView:apply];
    
    self.navigationItem.rightBarButtonItems = @[cartItem,shareItem,materialItem,applyItem];
}
- (void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xF6F7F8);
    self.tableView.showsVerticalScrollIndicator = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXGoodsInfoCell class]) bundle:nil] forCellReuseIdentifier:GoodsInfoCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXGoodsGiftCell class]) bundle:nil] forCellReuseIdentifier:GoodsGiftCell];
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
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXShopGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:ShopGoodsCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXHomeSectionHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeSectionHeader];
}
-(void)showClassSkuView:(UIButton *)sender
{
    if (!self.goodsDetail.enableSkus.count) {
        return;
    }
    
    self.chooseClassView.goodsDetail = self.goodsDetail;
    hx_weakify(self);
    self.chooseClassView.goodsHandleCall = ^(NSInteger type) {
        hx_strongify(weakSelf);
        [strongSelf.classPopVC dismissWithDuration:0.25 completion:nil];
        if (type) {
            // 1加入购物车 2立即购买
            if (sender.tag == 1) {
                 [strongSelf addOrderCartRequest];
            }else{
                GXUpOrderVC *ovc = [GXUpOrderVC new];
                ovc.goods_id = strongSelf.goods_id;//商品id
                ovc.goods_num = [NSString stringWithFormat:@"%ld",(long)strongSelf.goodsDetail.buyNum];//商品数量
                NSMutableString *specs_attrs = [NSMutableString string];
                if (strongSelf.goodsDetail.spec && strongSelf.goodsDetail.spec.count) {
                    for (GXGoodsDetailSpec *spec in strongSelf.goodsDetail.spec) {
                        if (specs_attrs.length) {
                            [specs_attrs appendFormat:@",%@",spec.selectSpec.attr_name];
                        }else{
                            [specs_attrs appendFormat:@"%@",spec.selectSpec.attr_name];
                        }
                    }
                }
                if (specs_attrs.length) {
                    if (strongSelf.goodsDetail.selectLogisticst.freight_type && strongSelf.goodsDetail.selectLogisticst.freight_type.length) {
                        [specs_attrs appendFormat:@",%@",strongSelf.goodsDetail.selectLogisticst.freight_type];
                    }
                }else{
                    if (strongSelf.goodsDetail.selectLogisticst.freight_type && strongSelf.goodsDetail.selectLogisticst.freight_type.length) {
                        [specs_attrs appendFormat:@"%@",strongSelf.goodsDetail.selectLogisticst.freight_type];
                    }
                }
                ovc.specs_attrs = specs_attrs;//商品规格
                ovc.sku_id = strongSelf.goodsDetail.sku.sku_id;
                ovc.freight_template_id = strongSelf.goodsDetail.selectLogisticst.freight_template_id;
                [strongSelf.navigationController pushViewController:ovc animated:YES];
            }
        }
    };
    [self.classPopVC showInView:self.view.window completion:nil];
}
#pragma mark -- 点击事件
-(void)cartClicked
{
    GXCartVC *cvc = [GXCartVC new];
    [self.navigationController pushViewController:cvc animated:YES];
}
-(void)shareClicked
{
    GXShareCodeView *share  = [GXShareCodeView loadXibView];
    share.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 180.f);
    hx_weakify(self);
    share.shareTypeCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        [strongSelf.sharePopVC dismissWithDuration:0.25 completion:nil];
        if (index == 1) {
            [strongSelf shareWebToPlatformType:UMSocialPlatformType_WechatTimeLine];
        }else{
            [strongSelf shareWebToPlatformType:UMSocialPlatformType_WechatSession];
        }
    };
    self.sharePopVC = [[zhPopupController alloc] initWithView:share size:share.bounds.size];
    self.sharePopVC.layoutType = zhPopupLayoutTypeBottom;
    [self.sharePopVC show];
}
-(void)materialClicked
{
    GXSaleMaterialVC *mvc = [GXSaleMaterialVC new];
    [self.navigationController pushViewController:mvc animated:YES];
}
-(void)applyClicked
{
    GXApplySupplyVC *wvc = [GXApplySupplyVC new];
    [self.navigationController pushViewController:wvc animated:YES];
}
- (IBAction)addCollectClicked:(SPButton *)sender {
    [self setCollectGoodsRequest];
}
- (IBAction)sankPriceClicked:(SPButton *)sender {
    GXSankPriceVC *pvc = [GXSankPriceVC new];
    pvc.goods_id = self.goods_id;
    pvc.sale_type = @"2";
    [self.navigationController pushViewController:pvc animated:YES];
}

- (IBAction)buyGoodsClicked:(UIButton *)sender {
    
    if (!self.goodsDetail.enableSkus) {
        hx_weakify(self);
        [self getGoodsSpecRequestCall:^{
            hx_strongify(weakSelf);
            [strongSelf showClassSkuView:sender];
        }];
    }else{
        [self showClassSkuView:sender];
    }
}
- (IBAction)applyJoinClicked:(UIButton *)sender {
    GXBrandDetailVC *bvc = [GXBrandDetailVC new];
    bvc.brand_id = self.goodsDetail.brand_id;
    [self.navigationController pushViewController:bvc animated:YES];
}
- (IBAction)customerBtnClicked:(UIButton *)sender {
    GXWebContentVC *wvc = [GXWebContentVC new];
    wvc.isNeedRequest = NO;
    wvc.url = [NSString stringWithFormat:@"https://ykf-webchat.7moor.com/wapchat.html?accessId=16f29a20-28bd-11eb-b145-57f963a2e61c&fromUrl=%@&urlTitle=%@&language=ZHCN&otherParams={\"agent\":\"%@\",\"peerId\":\"%@\",\"nickName\":\"%@\",\"cardInfo\":{\"left\":{\"url\": \"%@\"},\"right1\": {\"text\": \"%@\",\"color\": \"#595959\",\"fontSize\": 12},\"right2\": {\"text\": \" \",\"color\": \"#595959\",\"fontSize\": 12},\"right3\": {\"text\": \"%@\",\"color\": \"#ff6b6b\",\"fontSize\": 14}}}&clientId=shop_%@&customField={\"userName\":\"%@\",\"userId\":\"%@\",\"userPhone\":\"%@\"}",
               self.goodsDetail.provider_customer.fromUrl,
               self.goodsDetail.provider_customer.urlTitle,
               self.goodsDetail.provider_customer.agent,
               self.goodsDetail.provider_customer.peerId,
               [MSUserManager sharedInstance].curUserInfo.username,
               self.goodsDetail.cover_img,
               self.shop_name.text,
               self.rush_price.text,
               [MSUserManager sharedInstance].curUserInfo.uid,
               [MSUserManager sharedInstance].curUserInfo.username,
               [MSUserManager sharedInstance].curUserInfo.uid,
               [MSUserManager sharedInstance].curUserInfo.phone];
    [self.navigationController pushViewController:wvc animated:YES];
}
#pragma mark -- 接口请求
-(void)getGoodDetailRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"pre_sale_id"] = self.pre_sale_id;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getPreSaleDetail" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.goodsDetail = [GXGoodsDetail yy_modelWithDictionary:responseObject[@"data"]];
            NSMutableArray *materialLayouts = [NSMutableArray array];
            for (GXGoodsMaterial *material in strongSelf.goodsDetail.material) {
                GXGoodsMaterialLayout *layout = [[GXGoodsMaterialLayout alloc] initWithModel:material];
                [materialLayouts addObject:layout];
            }
            strongSelf.goodsDetail.materialLayout = [NSArray arrayWithArray:materialLayouts];
            
            NSMutableArray *commentLayouts = [NSMutableArray array];
            for (GXGoodsComment *comment in strongSelf.goodsDetail.eva) {
                GXGoodsCommentLayout *layout = [[GXGoodsCommentLayout alloc] initWithModel:comment];
                [commentLayouts addObject:layout];
            }
            strongSelf.goodsDetail.evaLayout = [NSArray arrayWithArray:commentLayouts];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleGoodsDetailData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            if ([[responseObject objectForKey:@"message"] containsString:@"下架"]) {
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)handleGoodsDetailData
{
    [self.cyclePagerView addSubview:self.carousel];
        
    // 处理倒计时和底部显示
    if ([self.goodsDetail.min_price floatValue] == [self.goodsDetail.max_price floatValue]) {
        self.rush_price.text = [NSString stringWithFormat:@"￥%@",self.goodsDetail.min_price];
    }else{
        self.rush_price.text = [NSString stringWithFormat:@"￥%@-￥%@",self.goodsDetail.min_price,self.goodsDetail.max_price];
    }
    /** 1未开始，2进行中；3已结束； */
    if ([self.goodsDetail.sell_status isEqualToString:@"1"]) {
        [self countTimeDown];
        if (!self.timer) {
            self.timer = [XTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTimeDown) userInfo:nil repeats:YES];
        }
    }else if ([self.goodsDetail.sell_status isEqualToString:@"2"]) {
        [self countTimeDown];
        if (!self.timer) {
            self.timer = [XTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTimeDown) userInfo:nil repeats:YES];
        }
    }else{
        self.rush_time.text = @"已结束";
        self.buttom_rush_time.text = @"已结束";
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
    
    [self.shop_name setTextWithLineSpace:5.f withString:_goodsDetail.goods_name withFont:[UIFont systemFontOfSize:15]];
    
    self.price.text = @"";
    self.market_price.text = [NSString stringWithFormat:@"建议零售价:￥%@",_goodsDetail.suggest_price];
    self.cale_num.text = [NSString stringWithFormat:@"销量：%@",_goodsDetail.sale_num];
        
    if (self.goodsDetail.important_notice && self.goodsDetail.important_notice.length) {// 有重要通知
        self.noticeView.hidden = NO;
        self.noticeViewButtom.constant = 12.f;
        self.notice.text = [NSString stringWithFormat:@"重要通知：%@",_goodsDetail.important_notice];
    }else{// 没有重要通知
        self.noticeView.hidden = YES;
        self.noticeViewButtom.constant = 0.f;
        self.notice.text = @"";
    }
    
    NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:0 14px;}</style></head><body>%@</body></html>",self.goodsDetail.goods_desc];
    [self.webView loadHTMLString:h5 baseURL:[NSURL URLWithString:HXRC_URL_HEADER]];
    
    [self.tableView reloadData];
    [self.collectionView reloadData];
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hx_strongify(weakSelf);
        strongSelf.tableViewHeight.constant = strongSelf.tableView.contentSize.height;
        strongSelf.collectionViewHeight.constant = strongSelf.collectionView.contentSize.height;
        strongSelf.contentScrollView.hidden = NO;
    });
    
    if ([self.goodsDetail.collected isEqualToString:@"1"]) {
        self.normal_collect.selected = YES;
    }
    
    if ([self.goodsDetail.control_type isEqualToString:@"1"]) {// 常规
        /** 1未开始，2进行中；3已结束 */
        if ([self.goodsDetail.sell_status isEqualToString:@"1"]) {
            self.normal_tool.hidden = YES;
            self.apply_tool.hidden = YES;
            self.rush_tool.hidden = NO;
        }else if ([self.goodsDetail.sell_status isEqualToString:@"2"]) {
            self.normal_tool.hidden = NO;
            self.apply_tool.hidden = YES;
            self.rush_tool.hidden = YES;
        }else{
            self.normal_tool.hidden = YES;
            self.apply_tool.hidden = YES;
            self.rush_tool.hidden = NO;
        }
    }else{// 控区控价
        if ([self.goodsDetail.is_join isEqualToString:@"1"]) {//已加盟，和常规商品一样
            /** 1未开始，2进行中；3已结束 */
            if ([self.goodsDetail.sell_status isEqualToString:@"1"]) {
                self.normal_tool.hidden = YES;
                self.apply_tool.hidden = YES;
                self.rush_tool.hidden = NO;
            }else if ([self.goodsDetail.sell_status isEqualToString:@"2"]) {
                self.normal_tool.hidden = NO;
                self.apply_tool.hidden = YES;
                self.rush_tool.hidden = YES;
            }else{
                self.normal_tool.hidden = YES;
                self.apply_tool.hidden = YES;
                self.rush_tool.hidden = NO;
            }
        }else{// 未加盟
            self.normal_tool.hidden = YES;
            self.apply_tool.hidden = NO;
            self.rush_tool.hidden = YES;
        }
    }
    
    if (self.goodsDetail.provider_customer && self.goodsDetail.provider_customer.peerId.length) {
        self.normal_customer_btn.hidden = NO;
    }else{
        self.normal_customer_btn.hidden = YES;
    }
}
-(void)setCollectGoodsRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goods_id;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/collectGood" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.normal_collect.selected = !strongSelf.normal_collect.selected;
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)addOrderCartRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goods_id;//商品id
    parameters[@"cart_num"] = @(self.goodsDetail.buyNum);//商品数量
    
    NSMutableString *specs_attrs = [NSMutableString string];
    if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
        for (GXGoodsDetailSpec *spec in self.goodsDetail.spec) {
            if (specs_attrs.length) {
                [specs_attrs appendFormat:@",%@",spec.selectSpec.attr_name];
            }else{
                [specs_attrs appendFormat:@"%@",spec.selectSpec.attr_name];
            }
        }
    }
    if (specs_attrs.length) {
        if (self.goodsDetail.selectLogisticst.freight_type && self.goodsDetail.selectLogisticst.freight_type.length) {
            [specs_attrs appendFormat:@",%@",self.goodsDetail.selectLogisticst.freight_type];
        }
    }else{
        if (self.goodsDetail.selectLogisticst.freight_type && self.goodsDetail.selectLogisticst.freight_type.length) {
            [specs_attrs appendFormat:@"%@",self.goodsDetail.selectLogisticst.freight_type];
        }
    }
    parameters[@"specs_attrs"] = specs_attrs;//商品规格
    
    parameters[@"is_try"] = self.goodsDetail.is_try;//是否试用装商品
    parameters[@"is_checked"] = @"1";//0未选择；1已选择
    parameters[@"freight_template_id"] = self.goodsDetail.selectLogisticst.freight_template_id;
    parameters[@"sku_id"] = self.goodsDetail.sku.sku_id;
 
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/addOrderCart" parameters:parameters success:^(id responseObject) {
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)shareNumRequest:(NSString *)material_id
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"material_id"] = material_id;
    
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/shareMaterial" parameters:parameters success:^(id responseObject) {
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getGoodsSpecRequestCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goods_id;
    
    hx_weakify(self);
    [MBProgressHUD showOnlyLoadToView:nil];
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getGoodsSpec" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [MBProgressHUD hideHUD];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.goodsDetail.enableSkus = [NSArray yy_modelArrayWithClass:[GXGoodsDetailSku class] json:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                completedCall();
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 倒计时
-(void)countTimeDown
{
    if (self.goodsDetail.count >0) {
        if ((self.goodsDetail.count/3600)/24) {
            NSString *str_day = [NSString stringWithFormat:@"%02ld",(self.goodsDetail.count/3600)/24];
            NSString *str_hour = [NSString stringWithFormat:@"%02ld",self.goodsDetail.count/3600%24];
            NSString *str_minute = [NSString stringWithFormat:@"%02ld",(self.goodsDetail.count%(60*60))/60];
            NSString *str_second = [NSString stringWithFormat:@"%02ld",self.goodsDetail.count%60];
            NSString *format_time = [NSString stringWithFormat:@"%@天%@:%@:%@",str_day,str_hour,str_minute,str_second];
            //设置文字显示 根据自己需求设置
            if ([self.goodsDetail.sell_status isEqualToString:@"1"]) {
                self.rush_time.text = [NSString stringWithFormat:@"距开始 %@",format_time];
                self.buttom_rush_time.text = format_time;
            }else if ([self.goodsDetail.sell_status isEqualToString:@"2"]) {
                self.rush_time.text = [NSString stringWithFormat:@"距结束 %@",format_time];
                self.buttom_rush_time.text = format_time;
            }else{
                self.rush_time.text = @"已结束";
                self.buttom_rush_time.text = @"已结束";
            }
        }else{
            NSString *str_hour = [NSString stringWithFormat:@"%02ld",self.goodsDetail.count/3600%24];
            NSString *str_minute = [NSString stringWithFormat:@"%02ld",(self.goodsDetail.count%(60*60))/60];
            NSString *str_second = [NSString stringWithFormat:@"%02ld",self.goodsDetail.count%60];
            NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
            //设置文字显示 根据自己需求设置
            if ([self.goodsDetail.sell_status isEqualToString:@"1"]) {
                self.rush_time.text = [NSString stringWithFormat:@"距开始 %@",format_time];
                self.buttom_rush_time.text = format_time;
            }else if ([self.goodsDetail.sell_status isEqualToString:@"2"]) {
                self.rush_time.text = [NSString stringWithFormat:@"距结束 %@",format_time];
                self.buttom_rush_time.text = format_time;
            }else{
                self.rush_time.text = @"已结束";
                self.buttom_rush_time.text = @"已结束";
            }
        }
        
        self.goodsDetail.count -= 1;
    }else{
        // 移除倒计时，发出通知并刷新页面
        self.goodsDetail.count = 0;
        if ([self.goodsDetail.sell_status isEqualToString:@"1"]) {
            self.goodsDetail.sell_status = @"2";
        }else if ([self.goodsDetail.sell_status isEqualToString:@"2"]) {
            self.goodsDetail.sell_status = @"3";
            [self.timer invalidate];
            self.timer = nil;
        }
        // 倒计时结束，刷新页面
        [self handleGoodsDetailData];
    }
}
- (void)shareWebToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //创建图片内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"呱选-好品预售" descr:self.goodsDetail.goods_name thumImage:HXGetImage(@"Icon-share")];
    //如果有缩略图，则设置缩略图
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@webRegister/page/dynamic.html?pre_sale_id=%@&is_join=%@",HXRC_URL_HEADER,self.pre_sale_id,self.goodsDetail.is_join];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}
#pragma mark -- XQCarousel代理
-(void)XQCarouselDidClickedImageView:(XQCarousel *)carousel imageViewIndex:(NSInteger)imageViewIndex
{
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i < self.goodsDetail.good_adv.count; i++) {
        GXGoodsDetailAdv *adv = self.goodsDetail.good_adv[i];
        if ([adv.adv_type isEqualToString:@"1"]) {// 图片类型
            NSMutableDictionary *temp = [NSMutableDictionary dictionary];
            temp[ZLPreviewPhotoObj] = [adv.adv_img hasPrefix:@"http"]?[NSURL URLWithString:adv.adv_img]:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HXRC_URL_HEADER,adv.adv_img]];
            temp[ZLPreviewPhotoTyp] = @(ZLPreviewPhotoTypeURLImage);
            [items addObject:temp];
        }else{
            imageViewIndex -= 1;// 如果存在视频类型，因为图片占第一位，图片的下标比正常情况会错位1
        }
    }
    
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    /**
     导航条颜色
     */
    actionSheet.configuration.navBarColor = [UIColor clearColor];
    /**
     底部工具栏按钮 可交互 状态标题颜色
     */
    actionSheet.configuration.statusBarStyle = UIStatusBarStyleLightContent;
    actionSheet.sender = self;
    [actionSheet previewPhotos:items index:imageViewIndex hideToolBar:YES complete:^(NSArray * _Nonnull photos) {
        
    }];
}
#pragma mark -- 事件监听
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.webContentViewHeight.constant = self.webView.scrollView.contentSize.height;
        self.webView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.webView.scrollView.contentSize.height);
    }
}
-(void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
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
#pragma mark -- TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if ((self.goodsDetail.gift_rule && self.goodsDetail.gift_rule.count) && (self.goodsDetail.rebate && self.goodsDetail.rebate.count)) {
            return 2;
        }else if ((self.goodsDetail.gift_rule && self.goodsDetail.gift_rule.count) || (self.goodsDetail.rebate && self.goodsDetail.rebate.count)) {
            return 1;
        }else{
            return 0;
        }
    }else if (section == 1) {
        return self.goodsDetail.materialLayout.count;
    }else if (section == 2) {
        return self.goodsDetail.evaLayout.count;
    }else{
        return self.goodsDetail.good_param.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50.f;
    }else if (indexPath.section == 1) {
        GXGoodsMaterialLayout *layout = self.goodsDetail.materialLayout[indexPath.row];
        return layout.height;
    }else if (indexPath.section == 2) {
        GXGoodsCommentLayout *layout = self.goodsDetail.evaLayout[indexPath.row];
        return layout.height;
    }else{
        return UITableViewAutomaticDimension;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GXGoodsGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodsGiftCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ((self.goodsDetail.gift_rule && self.goodsDetail.gift_rule.count) && (self.goodsDetail.rebate && self.goodsDetail.rebate.count)) {
            if (indexPath.row == 0) {
                cell.gift_rule = self.goodsDetail.gift_rule;
            }else{
                cell.rebate = self.goodsDetail.rebate;
            }
        }else if ((self.goodsDetail.gift_rule && self.goodsDetail.gift_rule.count)) {
            cell.gift_rule = self.goodsDetail.gift_rule;
        }else if (self.goodsDetail.rebate && self.goodsDetail.rebate.count) {
            cell.rebate = self.goodsDetail.rebate;
        }
        return cell;
    }else if (indexPath.section == 1) {
        GXGoodsMaterialCell * cell = [GXGoodsMaterialCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.targetVc = self;
        GXGoodsMaterialLayout *layout = self.goodsDetail.materialLayout[indexPath.row];
        cell.materialLayout = layout;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 2){
        GXGoodsCommentCell * cell = [GXGoodsCommentCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.targetVc = self;
        GXGoodsCommentLayout *layout = self.goodsDetail.evaLayout[indexPath.row];
        cell.commentLayout = layout;
        cell.delegate = self;
        return cell;
    }else{
        GXGoodsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodsInfoCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        GXGoodsDetailParam *param = self.goodsDetail.good_param[indexPath.row];
        cell.param = param;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }else if (section == 1) {
        return self.goodsDetail.materialLayout.count?44.f:CGFLOAT_MIN;
    }else if (section == 2) {
        return self.goodsDetail.evaLayout.count?44.f:CGFLOAT_MIN;
    }else{
        return self.goodsDetail.good_param.count?44.f:CGFLOAT_MIN;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if ((self.goodsDetail.gift_rule && self.goodsDetail.gift_rule.count) || (self.goodsDetail.rebate && self.goodsDetail.rebate.count)){
            return 10.f;
        }else{
            return CGFLOAT_MIN;
        }
    }else if (section == 1) {
        return self.goodsDetail.materialLayout.count?10.f:CGFLOAT_MIN;
    }else if (section == 2) {
        return self.goodsDetail.evaLayout.count?10.f:CGFLOAT_MIN;
    }else{
        return self.goodsDetail.good_param.count?10.f:CGFLOAT_MIN;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = UIColorFromRGB(0xF6F7F8);
    return footer;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }else {
        GXGoodsDetailSectionHeader *header = [GXGoodsDetailSectionHeader loadXibView];
        header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44.f);
        if (section == 1) {
            header.titleLabel.text = @"素材";
            header.moreImg.hidden = NO;
            header.moreTitle.hidden = NO;
        }else if (section == 2){
            header.titleLabel.text = @"评价";
            header.moreImg.hidden = NO;
            header.moreTitle.hidden = NO;
        }else{
            header.titleLabel.text = @"商品规格";
            header.moreImg.hidden = YES;
            header.moreTitle.hidden = YES;
        }
        hx_weakify(self);
        header.sectionClickCall = ^{
            hx_strongify(weakSelf);
            if (section == 1) {
                GXAllMaterialVC *mvc = [GXAllMaterialVC new];
                mvc.goods_id = strongSelf.goods_id;
                [strongSelf.navigationController pushViewController:mvc animated:YES];
            }else if (section == 2) {
                GXAllCommentVC *mvc = [GXAllCommentVC new];
                mvc.goods_id = strongSelf.goods_id;
                mvc.evaCount = strongSelf.goodsDetail.evaCount;
                mvc.goodsDetail = strongSelf.goodsDetail;
                [strongSelf.navigationController pushViewController:mvc animated:YES];
            }
        };
        if (section == 1) {
            return self.goodsDetail.materialLayout.count?header:nil;
        }else if (section == 2) {
            return self.goodsDetail.evaLayout.count?header:nil;
        }else{
            return self.goodsDetail.good_param.count?header:nil;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        hx_weakify(self);
        if ((self.goodsDetail.gift_rule && self.goodsDetail.gift_rule.count) && (self.goodsDetail.rebate && self.goodsDetail.rebate.count)) {
            if (indexPath.row == 0) {
                GXFullGiftView *giftView = [GXFullGiftView loadXibView];
                giftView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 300.f);
                giftView.gift_rule = self.goodsDetail.gift_rule;
                giftView.closeClickedCall = ^{
                    hx_strongify(weakSelf);
                    [strongSelf.sharePopVC dismiss];
                };
                self.sharePopVC = [[zhPopupController alloc] initWithView:giftView size:giftView.bounds.size];
                self.sharePopVC.layoutType = zhPopupLayoutTypeBottom;
                [self.sharePopVC show];
                
            }else{
                GXRebateView *rebateView = [GXRebateView loadXibView];
                rebateView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 400.f);
                rebateView.rebate = self.goodsDetail.rebate;
                rebateView.closeClickedCall = ^{
                    hx_strongify(weakSelf);
                    [strongSelf.sharePopVC dismiss];
                };
                self.sharePopVC = [[zhPopupController alloc] initWithView:rebateView size:rebateView.bounds.size];
                self.sharePopVC.layoutType = zhPopupLayoutTypeBottom;
                [self.sharePopVC show];
            }
        }else if ((self.goodsDetail.gift_rule && self.goodsDetail.gift_rule.count)) {
            GXFullGiftView *giftView = [GXFullGiftView loadXibView];
            giftView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 300.f);
            giftView.gift_rule = self.goodsDetail.gift_rule;
            giftView.closeClickedCall = ^{
                hx_strongify(weakSelf);
                [strongSelf.sharePopVC dismiss];
            };
            self.sharePopVC = [[zhPopupController alloc] initWithView:giftView size:giftView.bounds.size];
            self.sharePopVC.layoutType = zhPopupLayoutTypeBottom;
            [self.sharePopVC show];
        }else if (self.goodsDetail.rebate && self.goodsDetail.rebate.count) {
            GXRebateView *rebateView = [GXRebateView loadXibView];
            rebateView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 400.f);
            rebateView.rebate = self.goodsDetail.rebate;
            rebateView.closeClickedCall = ^{
                hx_strongify(weakSelf);
                [strongSelf.sharePopVC dismiss];
            };
            self.sharePopVC = [[zhPopupController alloc] initWithView:rebateView size:rebateView.bounds.size];
            self.sharePopVC.layoutType = zhPopupLayoutTypeBottom;
            [self.sharePopVC show];
        }
    }
}
#pragma mark -- GXGoodsMaterialCellDelegate
/** 点击了全文/收回 */
- (void)didClickMoreLessInCell:(GXGoodsMaterialCell *)Cell
{
    GXGoodsMaterialLayout *layout = Cell.materialLayout;
    layout.material.isOpening = !layout.material.isOpening;
    
    [layout resetLayout];
    [self.tableView reloadData];
}
/** 查看商品 */
- (void)didClickGoodsInCell:(GXGoodsMaterialCell *)Cell
{
    HXLog(@"查看商品");
}
/** 分享 */
- (void)didClickShareInCell:(GXGoodsMaterialCell *)Cell
{
    //HXLog(@"分享");
    self.shareModel = Cell.materialLayout;
    if (Cell.materialLayout.material.photos && Cell.materialLayout.material.photos.count) {
        [MBProgressHUD showLoadToView:nil title:@"图片处理中..."];
        hx_weakify(self);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            hx_strongify(weakSelf);
            GXSaveImageToPHAsset *savePh = [[GXSaveImageToPHAsset alloc] init];
            savePh.targetVC = strongSelf;
            [savePh saveImages:Cell.materialLayout.material.photos comletedCall:^(NSInteger result) {
                // 复制文本
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                    if (result != 0) {
                        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                        pasteboard.string = Cell.materialLayout.material.dsp;
                        
                        if (Cell.materialLayout.material.photos.count > 1) {
                            [strongSelf showShareView:YES];
                        }else{
                            [strongSelf showShareView:NO];
                        }
                    }else{
                        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相册权限" message:@"设置-隐私-相册" constantWidth:HX_SCREEN_WIDTH - 50*2];
                        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                            [strongSelf.sharePopVC dismiss];
                            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];//跳转到本应用的设置页面
                            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                [[UIApplication sharedApplication] openURL:url];
                            }
                        }];
                        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                        [alert addAction:okButton];
                        strongSelf.sharePopVC = [[zhPopupController alloc] initWithView:alert size:alert.bounds.size];
                        [strongSelf.sharePopVC show];
                    }
                });
            }];
        });
    }else{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = Cell.materialLayout.material.dsp;
        
        [self showShareView:NO];
    }
}
-(void)showShareView:(BOOL)isMorePicture
{
    GXShareView *share  = [GXShareView loadXibView];
    share.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 400.f);
    if (isMorePicture) {
        share.onlyWxView.hidden = NO;
    }else{
        share.onlyWxView.hidden = YES;
    }
    hx_weakify(self);
    share.shareTypeCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        [strongSelf.sharePopVC dismissWithDuration:0.25 completion:nil];

        if (index != 3) {
            [strongSelf shareNumRequest:strongSelf.shareModel.material.material_id];
            if (index == 0) {// 仅仅打开微信
                NSURL *url = [NSURL URLWithString:@"weixin://"];
                BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
                //先判断是否能打开该url
                if (canOpen) {//打开微信
                    [[UIApplication sharedApplication] openURL:url];
                }else {
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"您的设备未安装微信APP"];
                }
            }else{
                //创建分享消息对象
                NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:strongSelf.shareModel.material.photos.firstObject]];
                UIImage *image = [UIImage imageWithData:data]; // 取得图片
                
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:@"呱选-精品素材" descr:strongSelf.shareModel.material.dsp thumImage:image];
                shareObject.shareImage = image;
                messageObject.shareObject = shareObject;
                //调用分享接口
                [[UMSocialManager defaultManager] shareToPlatform:index==1?UMSocialPlatformType_WechatTimeLine:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                    if (error) {
                        UMSocialLogInfo(@"************Share fail with error %@*********",error);
                        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
                    }else{
                        if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                            UMSocialShareResponse *resp = data;
                            //分享结果消息
                            UMSocialLogInfo(@"response message is %@",resp.message);
                            //第三方原始返回的数据
                            UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                        }else{
                            UMSocialLogInfo(@"response data is %@",data);
                        }
                    }
                }];
            }
        }
    };
    self.sharePopVC = [[zhPopupController alloc] initWithView:share size:share.bounds.size];
    self.sharePopVC.layoutType = zhPopupLayoutTypeBottom;
    [self.sharePopVC show];
}
#pragma mark -- GXGoodsCommentCellDelegate
/** 点击了全文/收回 */
-(void)didClickMoreLessInCommentCell:(GXGoodsCommentCell *)Cell
{
    GXGoodsCommentLayout *layout = Cell.commentLayout;
    layout.comment.isOpening = !layout.comment.isOpening;
    
    [layout resetLayout];
    [self.tableView reloadData];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //为你推荐
    return self.goodsDetail.goods_recommend.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    //为你推荐
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    //为你推荐
    return 2;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //为你推荐
    GXShopGoodsCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShopGoodsCell forIndexPath:indexPath];
    GXGoodsRecommend *recommend = self.goodsDetail.goods_recommend[indexPath.item];
    cell.recommend = recommend;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(HX_SCREEN_WIDTH, 50.f);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        GXHomeSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeSectionHeader forIndexPath:indexPath];
        //为你推荐
        header.recommendView.hidden = NO;
        header.titleView.hidden = YES;
        
        return header;
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //为你推荐
    GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
    GXGoodsRecommend *recommend = self.goodsDetail.goods_recommend[indexPath.item];
    dvc.goods_id = recommend.goods_id;
    [self.navigationController pushViewController:dvc animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //为你推荐
    CGFloat width = (HX_SCREEN_WIDTH-10*3)/2.0;
    CGFloat height = width+70.f;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    //为你推荐
    return 5.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    //为你推荐
    return 5.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //为你推荐
    return  UIEdgeInsetsMake(0.f, 5.f, 15.f, 5.f);
}
@end
