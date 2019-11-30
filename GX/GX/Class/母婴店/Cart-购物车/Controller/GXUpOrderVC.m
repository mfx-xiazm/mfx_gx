//
//  GXUpOrderVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXUpOrderVC.h"
#import "GXUpOrderCell.h"
#import "GXUpOrderHeader.h"
#import "GXUpOrderFooter.h"
#import "GXChooseCouponVC.h"
#import "GXPayTypeVC.h"
#import "GXConfirmOrder.h"
#import "GXMyAddressVC.h"
#import "GXMyCoupon.h"
#import "GXMyAddress.h"

static NSString *const UpOrderCell = @"UpOrderCell";

@interface GXUpOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 总价 */
@property (weak, nonatomic) IBOutlet UILabel *total_pay_orice;
/* 头视图 */
@property(nonatomic,strong) GXUpOrderHeader *header;
/* 尾视图 */
@property(nonatomic,strong) GXUpOrderFooter *footer;
/* 订单 */
@property(nonatomic,strong) GXConfirmOrder *confirmOrder;

@end

@implementation GXUpOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"提交订单"];
    [self setUpTableView];
    [self startShimmer];
    [self getConfirmOrderDataRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 80.f);
    self.footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 100.f);
}
-(GXUpOrderHeader *)header
{
    if (_header == nil) {
        _header = [GXUpOrderHeader loadXibView];
        _header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 80.f);
        hx_weakify(self);
        _header.addressClickedCall = ^{
            hx_strongify(weakSelf);
            GXMyAddressVC *avc = [GXMyAddressVC new];
            avc.getAddressCall = ^(GXMyAddress * _Nonnull address) {
                if (strongSelf.confirmOrder.defaultAddress) {
                    if (![address.address_id isEqualToString:strongSelf.confirmOrder.defaultAddress.address_id]) {
                        strongSelf.confirmOrder.defaultAddress = address;
                        [strongSelf checkGoodsAreaRequest];//请求接口
                    }else{
                        strongSelf.confirmOrder.defaultAddress = address;
                    }
                }else{
                    strongSelf.confirmOrder.defaultAddress = address;
                    [strongSelf checkGoodsAreaRequest];//请求接口
                }
            };
            [strongSelf.navigationController pushViewController:avc animated:YES];
        };
    }
    return _header;
}
-(GXUpOrderFooter *)footer
{
    if (_footer == nil) {
        _footer = [GXUpOrderFooter loadXibView];
        _footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 100.f);
        hx_weakify(self);
        _footer.getCouponCall = ^{
            hx_strongify(weakSelf);
            GXChooseCouponVC *cvc = [GXChooseCouponVC new];
            cvc.provider_uid = @"0";
            if (strongSelf.confirmOrder.selectedPlatformCoupon) {
                cvc.selectCoupon = strongSelf.confirmOrder.selectedPlatformCoupon;
            }
            // 如果选择了商家优惠券，这里要减去商家的优惠券
            CGFloat shopCouponAmount = 0;
            for (GXConfirmOrderData *orderData in strongSelf.confirmOrder.goodsData) {
                if (orderData.selectedCoupon) {
                    shopCouponAmount += [orderData.selectedCoupon.coupon_amount floatValue];
                }
            }
            cvc.price_amount = [NSString stringWithFormat:@"%.2f",[strongSelf.confirmOrder.actTotalPrice floatValue] - shopCouponAmount];
            cvc.getUseCouponCall = ^(GXMyCoupon * _Nullable coupon) {
                if (coupon) {
                    strongSelf.confirmOrder.selectedPlatformCoupon = coupon;
                }else{
                    strongSelf.confirmOrder.selectedPlatformCoupon = nil;
                }
                [strongSelf handleConfirmOrderData];
            };
            [strongSelf.navigationController pushViewController:cvc animated:YES];
        };
    }
    return _footer;
}
#pragma mark -- 视图相关
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.rowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = HXGlobalBg;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXUpOrderCell class]) bundle:nil] forCellReuseIdentifier:UpOrderCell];
    
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
}
#pragma mark -- 接口请求
-(void)getConfirmOrderDataRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.isCartPush) {
        parameters[@"cart_ids"] = self.cart_ids;//商品id
    }else{
        parameters[@"goods_id"] = self.goods_id;//直接购买商品id
        parameters[@"goods_num"] = self.goods_num;//直接购买商品数量
        parameters[@"specs_attrs"] = self.specs_attrs;//直接购买商品规格
        parameters[@"sku_id"] = self.sku_id;//直接购买该商品的规格id
        parameters[@"logistics_com_id"] = self.logistics_com_id;//直接购买物流公司id
    }
   
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:self.isCartPush?@"admin/getConfirmOrderData":@"admin/getConfirmData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.confirmOrder = [GXConfirmOrder yy_modelWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.tableView.hidden = NO;
                [strongSelf handleConfirmOrderData];
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
-(void)checkGoodsAreaRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"address_id"] = self.confirmOrder.defaultAddress.address_id;//选择的收货地址id
    
    NSMutableString *skuDatas = [NSMutableString string];
    [skuDatas appendString:@"["];
    for (GXConfirmOrderData *orderData in self.confirmOrder.goodsData) {
        for (GXConfirmOrderGoods *orderGood in orderData.goods) {
            if (skuDatas.length == 1) {
                [skuDatas appendFormat:@"{\"sku_id\":\"%@\",\"cart_num\":\"%@\"}",orderGood.sku_id,orderGood.cart_num];
            }else{
                [skuDatas appendFormat:@",{\"sku_id\":\"%@\",\"cart_num\":\"%@\"}",orderGood.sku_id,orderGood.cart_num];
            }
        }
    }
    [skuDatas appendString:@"]"];
    parameters[@"skuDatas"] = skuDatas;//选择的商品的sku_id 和每个商品的cart_num数量
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/checkGoodsArea" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.confirmOrder = [GXConfirmOrder yy_modelWithDictionary:responseObject[@"data"]];
        }else{
            strongSelf.confirmOrder.defaultAddress = nil;
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.tableView.hidden = NO;
            [strongSelf handleConfirmOrderData];
        });
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)handleConfirmOrderData
{
    if (self.confirmOrder.defaultAddress) {
        self.header.noAddressView.hidden = YES;
        self.header.addressView.hidden = NO;
        self.header.defaultAddress = self.confirmOrder.defaultAddress;
    }else{
        self.header.noAddressView.hidden = NO;
        self.header.addressView.hidden = YES;
    }
    self.footer.confirmOrder = self.confirmOrder;
    
    [self.tableView reloadData];
    
    // actTotalPayAmount - 平台优惠券 - 各个商家的优惠券
    CGFloat shopCouponAmount = 0;
    for (GXConfirmOrderData *orderData in self.confirmOrder.goodsData) {
        if (orderData.selectedCoupon) {
            shopCouponAmount += [orderData.selectedCoupon.coupon_amount floatValue];
        }
    }
    if (self.confirmOrder.selectedPlatformCoupon) {
        self.total_pay_orice.text = [NSString stringWithFormat:@"￥%.2f",[self.confirmOrder.actTotalPayAmount floatValue]-[self.confirmOrder.selectedPlatformCoupon.coupon_amount floatValue]-shopCouponAmount];
    }else{
        self.total_pay_orice.text = [NSString stringWithFormat:@"￥%.2f",[self.confirmOrder.actTotalPayAmount floatValue]-shopCouponAmount];
    }
}
#pragma mark -- 点击事件
- (IBAction)upOrderClicked:(UIButton *)sender {
    if (!self.confirmOrder.defaultAddress) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择地址"];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.isCartPush) {
        parameters[@"cart_ids"] = self.cart_ids;//购物车选择多个商品对应的id
        parameters[@"address_id"] = self.confirmOrder.defaultAddress.address_id;//收货地址id
        NSMutableString *skuDatas = [NSMutableString string];
        [skuDatas appendString:@"["];
        for (GXConfirmOrderData *orderData in self.confirmOrder.goodsData) {
            for (GXConfirmOrderGoods *orderGood in orderData.goods) {
                if (skuDatas.length == 1) {
                    [skuDatas appendFormat:@"{\"sku_id\":\"%@\",\"cart_num\":\"%@\"}",orderGood.sku_id,orderGood.cart_num];
                }else{
                    [skuDatas appendFormat:@",{\"sku_id\":\"%@\",\"cart_num\":\"%@\"}",orderGood.sku_id,orderGood.cart_num];
                }
            }
        }
        [skuDatas appendString:@"]"];
        parameters[@"skuDatas"] = skuDatas;//选择的商品的sku_id 和每个商品的cart_num数量
    }else{
        GXConfirmOrderData *orderData = self.confirmOrder.goodsData.firstObject;
        GXConfirmOrderGoods *orderGood = orderData.goods.firstObject;
        
        parameters[@"goods_id"] = orderGood.goods_id;//商品id
        parameters[@"address_id"] = self.confirmOrder.defaultAddress.address_id;//收货地址id
        parameters[@"sku_id"] = orderGood.sku_id;//某个供应商下的该商品的id
        parameters[@"goods_num"] = self.goods_num;//直接购买商品的数量
        parameters[@"specs_attrs"] = orderGood.specs_attrs;//直接购买商品规格
        parameters[@"logistics_com_id"] = orderGood.logistics_com_id;//物流公司id
        NSMutableString *coupon_ids = [NSMutableString string];
        
        for (GXConfirmOrderData *orderData in self.confirmOrder.goodsData) {
            if (orderData.selectedCoupon) {
                if (coupon_ids.length) {
                    [coupon_ids appendFormat:@",%@",orderData.selectedCoupon.coupon_id];
                }else{
                    [coupon_ids appendFormat:@"%@",orderData.selectedCoupon.coupon_id];
                }
            }
        }
        if (self.confirmOrder.selectedPlatformCoupon) {
            if (coupon_ids.length) {
                [coupon_ids appendFormat:@",%@",self.confirmOrder.selectedPlatformCoupon.coupon_id];
            }else{
                [coupon_ids appendFormat:@"%@",self.confirmOrder.selectedPlatformCoupon.coupon_id];
            }
        }
        parameters[@"coupon_ids"] = coupon_ids;//用户选择的可使用的优惠券的id(包括平台或者店铺的)
    }

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:self.isCartPush?@"admin/saveOrder":@"admin/saveOrderData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (strongSelf.upOrderSuccessCall) {
                strongSelf.upOrderSuccessCall();
            }
            GXPayTypeVC *pvc = [GXPayTypeVC new];
            pvc.order_no = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"order_no"]];
            pvc.oid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"oid"]];
            [strongSelf.navigationController pushViewController:pvc animated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
    
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.confirmOrder.goodsData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXUpOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:UpOrderCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GXConfirmOrderData *orderData = self.confirmOrder.goodsData[indexPath.row];
    cell.orderData = orderData;
    hx_weakify(self);
    cell.chooseCouponCall = ^{
        hx_strongify(weakSelf);
        GXChooseCouponVC *cvc = [GXChooseCouponVC new];
        if (orderData.selectedCoupon) {
            cvc.selectCoupon = orderData.selectedCoupon;
        }
        cvc.provider_uid = orderData.provider_uid;
        cvc.price_amount = orderData.shopActTotalPrice;
        cvc.shop_name = orderData.shop_name;
        cvc.getUseCouponCall = ^(GXMyCoupon * _Nullable coupon) {
            if (coupon) {
                if (orderData.selectedCoupon) {// 如果之前存在已选择的商家优惠，并且优惠id不相同，就是更改了商家优惠，此时需要清空平台优惠，让用户重新选择
                    if (![orderData.selectedCoupon.coupon_id isEqualToString:coupon.coupon_id]) {
                        strongSelf.confirmOrder.selectedPlatformCoupon = nil;
                    }
                }else{//如果之前不存在已选择的商家优惠，现在选择了商家优惠，清空平台优惠，让用户重新选择
                    strongSelf.confirmOrder.selectedPlatformCoupon = nil;
                }
                orderData.selectedCoupon = coupon;
            }else{
                orderData.selectedCoupon = nil;
                // 清空了商家优惠券之后，清空平台优惠，让用户重新选择
                strongSelf.confirmOrder.selectedPlatformCoupon = nil;
            }
            [strongSelf handleConfirmOrderData];
        };
        [strongSelf.navigationController pushViewController:cvc animated:YES];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    GXConfirmOrderData *orderData = self.confirmOrder.goodsData[indexPath.row];
    if ([orderData.provider_uid isEqualToString:@"0"]) {
        return 40.f*3 + 110.f*orderData.goods.count + 10.f;
    }else{
        return 40.f*4 + 110.f*orderData.goods.count + 10.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
