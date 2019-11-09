//
//  GXCartVC.m
//  GX
//
//  Created by 夏增明 on 2019/9/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXCartVC.h"
#import "GXCartCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GXCartSectionHeader.h"
#import "GXCartSectionBgReusableView.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "GXGetCouponView.h"
#import "GXUpOrderVC.h"
#import "GXCartData.h"
#import "GXStoreGoodsListVC.h"
#import "GXMyCouponVC.h"
#import "GXMyCoupon.h"

static NSString *const CartCell = @"CartCell";
static NSString *const CartSectionHeader = @"CartSectionHeader";

@interface GXCartVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top_coupon_view_height;
@property (weak, nonatomic) IBOutlet UIButton *top_coupon_btn;
/* 编辑 */
@property(nonatomic,strong) UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIView *handleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *handleViewHeight;
/* 操作 */
@property (weak, nonatomic) IBOutlet UIButton *handleBtn;
/* 全选 */
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;
/* 总价 */
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
/* 商品数 */
@property (weak, nonatomic) IBOutlet UILabel *goods_num;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 购物车数组 */
@property (nonatomic,strong) NSMutableArray *cartDataArr;
/* 是否是提交订单 */
@property(nonatomic,assign) BOOL isUpOrder;
@end

@implementation GXCartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCollectionView];
    [self setUpRefresh];
    [self startShimmer];
    [self getOrderCartListRequest:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!self.isUpOrder) {
        [self editOrderCartRequest:^(BOOL isSuccess) {
            if (isSuccess) {
                HXLog(@"保存成功");
            }else{
                HXLog(@"保存失败");
            }
        }];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.isUpOrder = NO;
}
-(NSMutableArray *)cartDataArr
{
    if (_cartDataArr == nil) {
        _cartDataArr = [NSMutableArray array];
    }
    return _cartDataArr;
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"购物车"];
    
    UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
    edit.hxn_size = CGSizeMake(50, 40);
    edit.titleLabel.font = [UIFont systemFontOfSize:13];
    [edit setTitle:@"编辑" forState:UIControlStateNormal];
    [edit setTitle:@"完成" forState:UIControlStateSelected];
    [edit addTarget:self action:@selector(editClicked) forControlEvents:UIControlEventTouchUpInside];
    [edit setTitleColor:UIColorFromRGB(0XFFFFFF) forState:UIControlStateNormal];
    self.editBtn = edit;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:edit];
}
-(void)setUpCollectionView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXCartCell class]) bundle:nil] forCellWithReuseIdentifier:CartCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXCartSectionHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CartSectionHeader];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.collectionView.mj_footer resetNoMoreData];
        [strongSelf getOrderCartListRequest:YES];
    }];
    //追加尾部刷新
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getOrderCartListRequest:NO];
    }];
}
#pragma mark -- 接口请求
-(void)getOrderCartListRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getOrderCartData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.collectionView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                
                [strongSelf.cartDataArr removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXCartData class] json:responseObject[@"data"][@"cartData"]];
                [strongSelf.cartDataArr addObjectsFromArray:arrt];
            }else{
                [strongSelf.collectionView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                
                if ([responseObject[@"data"][@"cartData"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"cartData"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXCartData class] json:responseObject[@"data"][@"cartData"]];
                    [strongSelf.cartDataArr addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // 刷新界面
                hx_strongify(weakSelf);
                strongSelf.collectionView.hidden = NO;
                if ([responseObject[@"data"][@"coupon"] integerValue] == 1) {
                    strongSelf.top_coupon_btn.hidden = NO;
                    strongSelf.top_coupon_view_height.constant = 48.f;
                }else{
                    strongSelf.top_coupon_btn.hidden = YES;
                    strongSelf.top_coupon_view_height.constant = 10.f;
                }
                strongSelf.editBtn.hidden = !strongSelf.cartDataArr.count;
                strongSelf.handleView.hidden = !strongSelf.cartDataArr.count;
                strongSelf.handleViewHeight.constant = strongSelf.cartDataArr.count?44.f:0.f;
                [strongSelf checkIsAllSelect];
                [strongSelf calculateGoodsPrice];
                [strongSelf.collectionView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [strongSelf.collectionView.mj_header endRefreshing];
        [strongSelf.collectionView.mj_footer endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 业务逻辑
/**
 判断是否全选
 */
-(void)checkIsAllSelect
{
    __block BOOL isAllSelect = YES;
    [self.cartDataArr enumerateObjectsUsingBlock:^(GXCartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.is_checked) {
            isAllSelect = NO;
            *stop = YES;
        }
    }];
    self.selectAllBtn.selected = isAllSelect;
}
/**
 检查是否有选中的商品

 @return Yes存在选中/No不存在选中
 */
-(BOOL)checkIsHaveSelect
{
    __block BOOL isHaveSelect = NO;
    for (GXCartData *cart in self.cartDataArr) {
        [cart.goodsData enumerateObjectsUsingBlock:^(GXCartShopGoods * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.is_checked) {
                isHaveSelect = YES;
                *stop = YES;
            }
        }];
        if (isHaveSelect) {
            break;
        }
    }
    return isHaveSelect;
}
/**
 计算商品价格
 */
-(void)calculateGoodsPrice
{
    __block CGFloat price = 0;
    __block NSInteger  goodsNum = 0;
    for (GXCartData *cart in self.cartDataArr) {
        [cart.goodsData enumerateObjectsUsingBlock:^(GXCartShopGoods * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.is_checked) {
                price += ([obj.price floatValue])*[obj.cart_num integerValue];
                goodsNum ++;
            }
        }];
    }
    self.totalPrice.text = [NSString stringWithFormat:@"%.2f元",fabs(price)];
    self.goods_num.text = [NSString stringWithFormat:@"%ld个商品",(long)goodsNum];
}
-(void)delOrderCartRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    NSMutableString *cartIds = [NSMutableString string];
    for (GXCartData *cart in self.cartDataArr) {
        [cart.goodsData enumerateObjectsUsingBlock:^(GXCartShopGoods * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.is_checked) {
                [cartIds appendFormat:@"%@",cartIds.length?[NSString stringWithFormat:@",%@",obj.cart_id]:[NSString stringWithFormat:@"%@",obj.cart_id]];
            }
        }];
    }
    parameters[@"cartIds"] = cartIds;//删除多个id间用逗号隔开

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/delOrderCart" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            [strongSelf getOrderCartListRequest:YES];// 刷新页面
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)editOrderCartRequest:(void(^)(BOOL isSuccess))completeCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableString *cartData = [NSMutableString string];
    [cartData appendString:@"["];
    for (GXCartData *cart in self.cartDataArr) {
        [cart.goodsData enumerateObjectsUsingBlock:^(GXCartShopGoods * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (cartData.length == 1) {
                [cartData appendFormat:@"{\"cart_id\":\"%@\",\"cart_num\":\"%@\",\"is_checked\":\"%@\"}",obj.cart_id,obj.cart_num,@(obj.is_checked)];
            }else{
                [cartData appendFormat:@",{\"cart_id\":\"%@\",\"cart_num\":\"%@\",\"is_checked\":\"%@\"}",obj.cart_id,obj.cart_num,@(obj.is_checked)];
            }
        }];
    }
    [cartData appendString:@"]"];
    parameters[@"cartData"] = cartData;//cartData
    
    //hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/editOrderCart" parameters:parameters success:^(id responseObject) {
        //hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            completeCall(YES);
        }else{
            completeCall(NO);
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        //hx_strongify(weakSelf);
        completeCall(NO);
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getShopCouponRequest:(GXCartData *)cartData  completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"provider_uid"] = cartData.provider_uid;//店铺id

    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getCoupon" parameters:parameters success:^(id responseObject) {
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXMyCoupon class] json:responseObject[@"data"]];
            cartData.coupons = [NSArray arrayWithArray:arrt];
            completedCall();
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 点击事件
-(void)editClicked
{
    self.editBtn.selected = !self.editBtn.isSelected;
    if (self.editBtn.isSelected) {
        [self.handleBtn setTitle:@"删除" forState:UIControlStateNormal];
    }else{
        [self.handleBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    }
}
- (IBAction)getCouponClicked:(UIButton *)sender {
    GXMyCouponVC *cvc = [GXMyCouponVC new];
    [self.navigationController pushViewController:cvc animated:YES];
}

- (IBAction)selectAllClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    // 改变该商铺商品的选中状态
    for (GXCartData *cart in self.cartDataArr) {
        cart.is_checked = sender.selected;
        [cart.goodsData enumerateObjectsUsingBlock:^(GXCartShopGoods * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.is_checked = sender.selected;
        }];
    }
    
    [self calculateGoodsPrice];

    [self.collectionView reloadData];
}
- (IBAction)upLoadOrderClicked:(UIButton *)sender {
    if (![self checkIsHaveSelect]) {
           [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择商品"];
           return;
    }
    
    if (self.editBtn.isSelected) {//删除
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要删除选中商品吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
        hx_weakify(self);
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
        }];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"删除" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
            [strongSelf delOrderCartRequest];
        }];
        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
        self.zh_popupController = [[zhPopupController alloc] init];
        [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
    }else{
        self.isUpOrder = YES;
        hx_weakify(self);
        [self editOrderCartRequest:^(BOOL isSuccess) {
            hx_strongify(weakSelf);
            if (isSuccess) {
                GXUpOrderVC *ovc = [GXUpOrderVC new];
                NSMutableString *cart_id = [NSMutableString string];
                for (GXCartData *cart in strongSelf.cartDataArr) {
                    [cart.goodsData enumerateObjectsUsingBlock:^(GXCartShopGoods * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj.is_checked) {
                            [cart_id appendFormat:@"%@",cart_id.length?[NSString stringWithFormat:@",%@",obj.cart_id]:[NSString stringWithFormat:@"%@",obj.cart_id]];
                        }
                    }];
                }
                ovc.isCartPush = YES;
                ovc.cart_ids = cart_id;//cart_id
                ovc.upOrderSuccessCall = ^{
                    [strongSelf getOrderCartListRequest:YES];
                };
                [strongSelf.navigationController pushViewController:ovc animated:YES];
            }
        }];
    }
}

#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.cartDataArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    GXCartData *cartData = self.cartDataArr[section];
    return cartData.goodsData.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GXCartCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CartCell forIndexPath:indexPath];
    GXCartData *cartData = self.cartDataArr[indexPath.section];
    GXCartShopGoods *goods = cartData.goodsData[indexPath.row];
    cell.goods = goods;
    hx_weakify(self);
    cell.cartHandleCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        if (index == 2) {
            if (!goods.is_checked) {//取消选中
                cartData.is_checked = NO;
            }else{//选中
                // 判断店铺要选中
                __block BOOL isStoreSelect = YES;
                [cartData.goodsData enumerateObjectsUsingBlock:^(GXCartShopGoods * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (!obj.is_checked) {
                        isStoreSelect = NO;
                        *stop = YES;
                    }
                }];
                cartData.is_checked = isStoreSelect;
            }
            // 判断是否全选
            [strongSelf checkIsAllSelect];
            // 计算商品价格
            [strongSelf calculateGoodsPrice];
            
            [collectionView reloadData];
        }else{
            [strongSelf calculateGoodsPrice];
        }
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.hxn_width, 40.f);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        GXCartSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CartSectionHeader forIndexPath:indexPath];
        GXCartData *cartData = self.cartDataArr[indexPath.section];
        header.cartData = cartData;
        hx_weakify(self);
        header.cartHeaderClickedCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            if (index == 1) {
                // 改变该店铺商品的选中状态
                [cartData.goodsData enumerateObjectsUsingBlock:^(GXCartShopGoods * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.is_checked = cartData.is_checked;
                }];
                if (!cartData.is_checked) { // 取消选中
                    strongSelf.selectAllBtn.selected = cartData.is_checked;
                }else{//选中
                    // 判断是否全选
                    [strongSelf checkIsAllSelect];
                }
                // 计算商品价格
                [strongSelf calculateGoodsPrice];
                [collectionView reloadData];
            }else if (index == 2) {
                if (![cartData.provider_uid isEqualToString:@"0"]) {// 不是平台自营
                    GXStoreGoodsListVC *gvc = [GXStoreGoodsListVC new];
                    gvc.provider_uid = cartData.provider_uid;
                    [strongSelf.navigationController pushViewController:gvc animated:YES];
                }
            }else{
                if (cartData.coupons && cartData.coupons.count) {
                    GXGetCouponView *vdv = [GXGetCouponView loadXibView];
                    vdv.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 360);
                    vdv.cartData = cartData;
                    vdv.closeViewCall = ^{
                        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
                    };
                    strongSelf.zh_popupController = [[zhPopupController alloc] init];
                    strongSelf.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
                    [strongSelf.zh_popupController presentContentView:vdv duration:0.25 springAnimated:NO];
                }else{
                    [strongSelf getShopCouponRequest:cartData completedCall:^{
                        GXGetCouponView *vdv = [GXGetCouponView loadXibView];
                        vdv.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 360);
                        vdv.cartData = cartData;
                        vdv.closeViewCall = ^{
                            [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
                        };
                        strongSelf.zh_popupController = [[zhPopupController alloc] init];
                        strongSelf.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
                        [strongSelf.zh_popupController presentContentView:vdv duration:0.25 springAnimated:NO];
                    }];
                }
            }
        };
        return header;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = collectionView.hxn_width-20.f;
    CGFloat height = 110.f;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(0.f, 10.f, 10.f, 10.f);
}
- (NSString*)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout registerBackView:(NSInteger)section {
    return @"GXCartSectionBgReusableView";
}
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout attachToTop:(NSInteger)section {
    return YES;
}
@end
