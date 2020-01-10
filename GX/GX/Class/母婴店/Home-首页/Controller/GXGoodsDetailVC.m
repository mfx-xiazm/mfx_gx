//
//  GXGoodsDetailVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXGoodsDetailVC.h"
#import "GXGoodsMaterialCell.h"
#import "GXGoodsMaterialLayout.h"
#import "GXGoodsCommentLayout.h"
#import "GXGoodsCommentCell.h"
#import "GXAllMaterialVC.h"
#import "GXAllCommentVC.h"
#import "GXGoodsDetailSectionHeader.h"
#import "GXGoodsDetailHeader.h"
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

static NSString *const GoodsInfoCell = @"GoodsInfoCell";
@interface GXGoodsDetailVC ()<UITableViewDelegate,UITableViewDataSource,GXGoodsMaterialCellDelegate,GXGoodsCommentCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *normal_tool;
@property (weak, nonatomic) IBOutlet UIButton *normal_buy_btn;
@property (weak, nonatomic) IBOutlet UIButton *normal_add_btn;
@property (weak, nonatomic) IBOutlet UIView *try_tool;
@property (weak, nonatomic) IBOutlet UIView *control_tool;
@property (weak, nonatomic) IBOutlet SPButton *normal_collect;
@property (weak, nonatomic) IBOutlet SPButton *try_collect;
@property (weak, nonatomic) IBOutlet SPButton *control_collect;
/* 卖货素材 */
@property(nonatomic,weak) UIButton *materialBtn;
/* 我要供货 */
@property(nonatomic,weak) UIButton *applyBtn;
/* 头视图 */
@property(nonatomic,strong) GXGoodsDetailHeader *header;
/* 规格视图 */
@property(nonatomic,strong) GXChooseClassView *chooseClassView;
/** 尾部视图 */
@property(nonatomic,strong) UIView *footer;
/* 详情 */
@property(nonatomic,strong) WKWebView *webView;
/* 缓存自适应的cell高度 */
@property(nonatomic,strong) NSMutableDictionary *cellHeightsDictionary;
/* 商品详情 */
@property(nonatomic,strong) GXGoodsDetail *goodsDetail;
/** 分享数据模型 */
@property (nonatomic,strong) GXGoodsMaterialLayout *shareModel;
@end

@implementation GXGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self startShimmer];
    [self getGoodDetailRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.materialBtn.layer.cornerRadius = self.materialBtn.hxn_height/2.0;
    self.applyBtn.layer.cornerRadius = self.applyBtn.hxn_height/2.0;
}
-(NSMutableDictionary *)cellHeightsDictionary
{
    if (_cellHeightsDictionary == nil) {
        _cellHeightsDictionary = [NSMutableDictionary dictionary];
    }
    return _cellHeightsDictionary;
}
-(GXGoodsDetailHeader *)header
{
    if (_header == nil) {
        _header = [GXGoodsDetailHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, HX_SCREEN_WIDTH*2/3.0 + 50.f + 150);
    }
    return _header;
}
-(GXChooseClassView *)chooseClassView
{
    if (_chooseClassView == nil) {
        _chooseClassView = [GXChooseClassView loadXibView];
        _chooseClassView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 380);
    }
    return _chooseClassView;
}
-(WKWebView *)webView
{
    if (_webView == nil) {
        _webView = [[WKWebView alloc] init];
        _webView.scrollView.scrollEnabled = NO;
        [self.footer addSubview:_webView];
        [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}
-(UIView *)footer
{
    if (_footer == nil) {
        _footer = [UIView new];
        UIImageView *image = [[UIImageView alloc] init];
        image.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 60.f);
        image.backgroundColor = [UIColor whiteColor];
        image.contentMode = UIViewContentModeCenter;
        image.image = HXGetImage(@"商品描述");
        [_footer addSubview:image];
    }
    return _footer;
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    UIBarButtonItem *cartItem = [UIBarButtonItem itemWithTarget:self action:@selector(cartClicked) image:HXGetImage(@"购物车白")];
//    UIBarButtonItem *shareItem = [UIBarButtonItem itemWithTarget:self action:@selector(shareClicked) image:HXGetImage(@"分享白色")];
    
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
    
    self.navigationItem.rightBarButtonItems = @[cartItem,materialItem,applyItem];
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
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXGoodsInfoCell class]) bundle:nil] forCellReuseIdentifier:GoodsInfoCell];
}
#pragma mark -- 点击事件
-(void)cartClicked
{
    GXCartVC *cvc = [GXCartVC new];
    [self.navigationController pushViewController:cvc animated:YES];
}
-(void)shareClicked
{
    HXLog(@"分享");
}
-(void)materialClicked
{
    GXSaleMaterialVC *mvc = [GXSaleMaterialVC new];
    [self.navigationController pushViewController:mvc animated:YES];
}
-(void)applyClicked
{
    GXWebContentVC *wvc = [GXWebContentVC new];
    wvc.navTitle = @"申请供货";
    wvc.isNeedRequest = YES;
    wvc.requestType = 2;
    [self.navigationController pushViewController:wvc animated:YES];
}
- (IBAction)addCollectClicked:(SPButton *)sender {
    [self setCollectGoodsRequest];
}

- (IBAction)sankPriceClicked:(SPButton *)sender {
    GXSankPriceVC *pvc = [GXSankPriceVC new];
    pvc.goods_id = self.goods_id;
    [self.navigationController pushViewController:pvc animated:YES];
}

- (IBAction)buyGoodsClicked:(UIButton *)sender {
    
    self.chooseClassView.goodsDetail = self.goodsDetail;
    hx_weakify(self);
    self.chooseClassView.goodsHandleCall = ^(NSInteger type) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
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
                    [specs_attrs appendFormat:@",%@",strongSelf.goodsDetail.selectLogisticst.logistics_com_name];
                }else{
                    [specs_attrs appendFormat:@"%@",strongSelf.goodsDetail.selectLogisticst.logistics_com_name];
                }
                ovc.specs_attrs = specs_attrs;//商品规格
                ovc.sku_id = strongSelf.goodsDetail.sku.sku_id;
                ovc.logistics_com_id = strongSelf.goodsDetail.selectLogisticst.logistics_com_id;
                [strongSelf.navigationController pushViewController:ovc animated:YES];
            }
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:self.chooseClassView duration:0.25 springAnimated:NO];
}
- (IBAction)applyJoinClicked:(UIButton *)sender {
    if (self.isBrandPush) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        GXBrandDetailVC *bvc = [GXBrandDetailVC new];
        bvc.brand_id = self.goodsDetail.brand_id;
        [self.navigationController pushViewController:bvc animated:YES];
    }
}
#pragma mark -- 接口请求
-(void)getGoodDetailRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goods_id;
    if (self.rushbuy_id) {
        parameters[@"rushbuy_id"] = self.rushbuy_id;//爆款抢购id 常规商品和控区控价商品无该字段 则不需要传
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getGoodDetail" parameters:parameters success:^(id responseObject) {
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
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)handleGoodsDetailData
{
    self.header.goodsDetail = self.goodsDetail;
    
    CGFloat nameHeight = [self.goodsDetail.goods_name textHeightSize:CGSizeMake(HX_SCREEN_WIDTH-15*2.f, CGFLOAT_MAX) font:[UIFont systemFontOfSize:15] lineSpacing:5.f];
    CGRect headerFrame = CGRectZero;
    if ([self.goodsDetail.rushbuy isEqualToString:@"1"]) {//抢购商品
        self.header.rushView.hidden = NO;
        self.header.rushViewHeight.constant = 50.f;
        if (self.goodsDetail.important_notice && self.goodsDetail.important_notice.length) {// 有重要通知
            self.header.noticeView.hidden = NO;
            self.header.noticeViewHeight.constant = 40.f;
            headerFrame = CGRectMake(0, 0, HX_SCREEN_WIDTH, HX_SCREEN_WIDTH*2/3.0 + 50.f + nameHeight + 100.f + 10.f);
        }else{// 没有重要通知
            self.header.noticeView.hidden = YES;
            self.header.noticeViewHeight.constant = 0.f;
            headerFrame = CGRectMake(0, 0, HX_SCREEN_WIDTH, HX_SCREEN_WIDTH*2/3.0 + 50.f + nameHeight + 50.f + 10.f);
        }
    }else{//非抢购商品
        self.header.rushView.hidden = YES;
        self.header.rushViewHeight.constant = 0.f;
        
        if (self.goodsDetail.important_notice && self.goodsDetail.important_notice.length) {// 有重要通知
            self.header.noticeView.hidden = NO;
            self.header.noticeViewHeight.constant = 40.f;
            headerFrame = CGRectMake(0, 0, HX_SCREEN_WIDTH, HX_SCREEN_WIDTH*2/3.0 + nameHeight + 100.f + 10.f);
        }else{// 没有重要通知
            self.header.noticeView.hidden = YES;
            self.header.noticeViewHeight.constant = 0.f;
            headerFrame = CGRectMake(0, 0, HX_SCREEN_WIDTH, HX_SCREEN_WIDTH*2/3.0 + nameHeight + 50.f + 10.f);
        }
    }
    
    self.header.frame = headerFrame;
    hx_weakify(self);
    self.header.countDownCall = ^{// 倒计时结束，刷新页面
        hx_strongify(weakSelf);
        [strongSelf getGoodDetailRequest];
    };
    self.tableView.tableHeaderView = self.header;

    if ([self.goodsDetail.control_type isEqualToString:@"1"]) {// 常规
        self.normal_tool.hidden = NO;
        self.try_tool.hidden = YES;
        self.control_tool.hidden = YES;
        if ([self.goodsDetail.collected isEqualToString:@"1"]) {
            self.normal_collect.selected = YES;
        }
        if ([self.goodsDetail.rushbuy isEqualToString:@"1"]) {//抢购商品
            /** 1未开始，2进行中；3已结束；4暂停 */
            if ([self.goodsDetail.rush.rushbuy_status isEqualToString:@"2"]) {
                self.normal_buy_btn.userInteractionEnabled = YES;
                self.normal_add_btn.userInteractionEnabled = YES;
            }else{
                self.normal_buy_btn.userInteractionEnabled = NO;
                self.normal_add_btn.userInteractionEnabled = NO;
                [self.normal_buy_btn setBackgroundColor:UIColorFromRGB(0XDDDDDD)];
                [self.normal_add_btn setBackgroundColor:UIColorFromRGB(0XDDDDDD)];
            }
        }else{//非抢购商品
            self.normal_buy_btn.userInteractionEnabled = YES;
            self.normal_add_btn.userInteractionEnabled = YES;
        }
    }else{// 控区控价
        if ([self.goodsDetail.is_try isEqualToString:@"1"]) {// 试用装
            self.normal_tool.hidden = YES;
            self.try_tool.hidden = NO;
            self.control_tool.hidden = YES;
            if ([self.goodsDetail.collected isEqualToString:@"1"]) {
                self.try_collect.selected = YES;
            }
        }else{// 非试用装
            if ([self.goodsDetail.is_join isEqualToString:@"1"]) {//已加盟，和常规商品一样
                self.normal_tool.hidden = NO;
                self.try_tool.hidden = YES;
                self.control_tool.hidden = YES;
                if ([self.goodsDetail.collected isEqualToString:@"1"]) {
                    self.normal_collect.selected = YES;
                }
            }else{// 未加盟
                self.normal_tool.hidden = YES;
                self.try_tool.hidden = YES;
                self.control_tool.hidden = NO;
                if ([self.goodsDetail.collected isEqualToString:@"1"]) {
                    self.control_collect.selected = YES;
                }
            }
        }
    }
    NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:0 14px;}</style></head><body>%@</body></html>",self.goodsDetail.goods_desc];
    [self.webView loadHTMLString:h5 baseURL:[NSURL URLWithString:HXRC_URL_HEADER]];

    [self.tableView reloadData];
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
                strongSelf.try_collect.selected = !strongSelf.try_collect.selected;
                strongSelf.control_collect.selected = !strongSelf.control_collect.selected;
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
        [specs_attrs appendFormat:@",%@",self.goodsDetail.selectLogisticst.logistics_com_name];
    }else{
        [specs_attrs appendFormat:@"%@",self.goodsDetail.selectLogisticst.logistics_com_name];
    }
    parameters[@"specs_attrs"] = specs_attrs;//商品规格
    
    parameters[@"is_try"] = self.goodsDetail.is_try;//是否试用装商品
    parameters[@"is_checked"] = @"1";//0未选择；1已选择
    parameters[@"logistics_com_id"] = self.goodsDetail.selectLogisticst.logistics_com_id;
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
#pragma mark -- 事件监听
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.webView.frame = CGRectMake(0, 60.f, HX_SCREEN_WIDTH, self.webView.scrollView.contentSize.height);
        self.footer.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.webView.scrollView.contentSize.height + 60.f);
        self.tableView.tableFooterView = self.footer;
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
#pragma mark -- TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.goodsDetail.materialLayout.count;
    }else if (section == 1) {
        return self.goodsDetail.evaLayout.count;
    }else{
        return self.goodsDetail.good_param.count;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        [self.cellHeightsDictionary setObject:@(cell.frame.size.height) forKey:indexPath];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GXGoodsMaterialLayout *layout = self.goodsDetail.materialLayout[indexPath.row];
        return layout.height;
    }else if (indexPath.section == 1) {
        GXGoodsCommentLayout *layout = self.goodsDetail.evaLayout[indexPath.row];
        return layout.height;
    }else{
        NSNumber *height = [self.cellHeightsDictionary objectForKey:indexPath];
        if (height) return height.doubleValue;
        return UITableViewAutomaticDimension;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GXGoodsMaterialCell * cell = [GXGoodsMaterialCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.targetVc = self;
        GXGoodsMaterialLayout *layout = self.goodsDetail.materialLayout[indexPath.row];
        cell.materialLayout = layout;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 1){
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
        return self.goodsDetail.materialLayout.count?44.f:CGFLOAT_MIN;
    }else if (section == 1) {
        return self.goodsDetail.evaLayout.count?44.f:CGFLOAT_MIN;
    }else{
        return self.goodsDetail.good_param.count?44.f:CGFLOAT_MIN;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return self.goodsDetail.materialLayout.count?10.f:CGFLOAT_MIN;
    }else if (section == 1) {
        return self.goodsDetail.evaLayout.count?10.f:CGFLOAT_MIN;
    }else{
        return self.goodsDetail.good_param.count?10.f:CGFLOAT_MIN;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GXGoodsDetailSectionHeader *header = [GXGoodsDetailSectionHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44.f);
    if (section == 0) {
        header.titleLabel.text = @"素材";
        header.moreImg.hidden = NO;
        header.moreTitle.hidden = NO;
    }else if (section == 1){
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
        if (section == 0) {
            GXAllMaterialVC *mvc = [GXAllMaterialVC new];
            mvc.goods_id = strongSelf.goods_id;
            [strongSelf.navigationController pushViewController:mvc animated:YES];
        }else if (section == 1) {
            GXAllCommentVC *mvc = [GXAllCommentVC new];
            mvc.goods_id = strongSelf.goods_id;
            mvc.evaCount = strongSelf.goodsDetail.evaCount;
            mvc.goodsDetail = strongSelf.goodsDetail;
            [strongSelf.navigationController pushViewController:mvc animated:YES];
        }
    };
    if (section == 0) {
        return self.goodsDetail.materialLayout.count?header:nil;
    }else if (section == 1) {
        return self.goodsDetail.evaLayout.count?header:nil;
    }else{
        return self.goodsDetail.good_param.count?header:nil;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
            [savePh saveImages:Cell.materialLayout.material.photos comletedCall:^{
                // 复制文本
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = Cell.materialLayout.material.dsp;
                    
                    [strongSelf showShareView];
                });
                
            }];
        });
    }else{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = Cell.materialLayout.material.dsp;
        
        [self showShareView];
    }
}
-(void)showShareView
{
    GXShareView *share  = [GXShareView loadXibView];
    share.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 180.f);
    hx_weakify(self);
    share.shareTypeCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        [strongSelf shareNumRequest:strongSelf.shareModel.material.material_id];

        NSURL *url = [NSURL URLWithString:@"weixin://"];
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
        //先判断是否能打开该url
        if (canOpen) {   //打开微信
            [[UIApplication sharedApplication] openURL:url];
        }else {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"您的设备未安装微信APP"];
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:share duration:0.25 springAnimated:NO];
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
@end
