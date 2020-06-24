//
//  GXConfirmOrder.h
//  GX
//
//  Created by 夏增明 on 2019/11/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMyAddress,GXConfirmOrderData,GXConfirmOrderGoods,GXMyCoupon,GXConfirmBrandRebate,GXConfirmGoodsGift;
@interface GXConfirmOrder : NSObject
/* 地址 */
@property(nonatomic,strong) GXMyAddress *_Nullable defaultAddress;
/* 商品 */
@property(nonatomic,strong) NSArray<GXConfirmOrderData *> *goodsData;

@property(nonatomic,copy) NSString *discount_amount;
/// 未加运费并且计算了会员权益的总价格
@property(nonatomic,copy) NSString *actTotalPrice;
/// 加了运费没有计算会员权益的总价格
@property(nonatomic,copy) NSString *totalPayAmount;
/// 加了运费并且计算了会员权益的但是未减平台优惠和商家优惠总价格
@property(nonatomic,copy) NSString *actTotalPayAmount;
@property(nonatomic,copy) NSString *discount;

@property(nonatomic,strong) GXMyCoupon * _Nullable selectedPlatformCoupon;
@end

@interface GXConfirmOrderData : NSObject
@property(nonatomic,copy) NSString *provider_uid;
@property(nonatomic,copy) NSString *shop_name;
/// 店铺所有商品价格—优惠
@property(nonatomic,copy) NSString *shopActTotalPrice;
/// 店铺所有商品价格—优惠+运费
@property(nonatomic,copy) NSString *shopActTotalAmount;
/// 店铺所有商品的运费
@property(nonatomic,copy) NSString *shopActTotalFreight;
/// 店铺所有商品的初始价格（没有计算运费和其他优惠）
@property(nonatomic,copy) NSString *shopTotalPrice;
/// 店铺所有商品的返利
@property(nonatomic,copy) NSString *shopRebateAmount;
/// 备注
@property(nonatomic,copy) NSString *shopGoodsRemark;
@property(nonatomic,strong) NSArray<GXConfirmOrderGoods *> *goods;
@property(nonatomic,strong) NSArray<GXConfirmBrandRebate *> *brand_rebate;
@property(nonatomic,strong) NSArray<GXConfirmGoodsGift *> *gift_data;
@property(nonatomic,strong) NSArray<GXMyCoupon *> *shopCouponData;
@property(nonatomic,strong) GXMyCoupon * _Nullable selectedCoupon;

@end

@interface GXConfirmBrandRebate : NSObject
@property(nonatomic,copy) NSString *rebate_id;
@property(nonatomic,copy) NSString *rebate_percent;
@property(nonatomic,copy) NSString *begin_price;
@property(nonatomic,copy) NSString *goods_amount;
@property(nonatomic,copy) NSString *goods_rebate_amount;
@property(nonatomic,copy) NSString *goods_act_amount;
@property(nonatomic,copy) NSString *brand_id;
@property(nonatomic,copy) NSString *brand_name;
@property(nonatomic,copy) NSString *rebate_goods;

@end

@interface GXConfirmGoodsGift : NSObject
@property(nonatomic,copy) NSString *goods_gift_rule_id;
@property(nonatomic,copy) NSString *sale_id;
@property(nonatomic,copy) NSString *goods_area_id;
@property(nonatomic,copy) NSString *gift_rule_interval_id;
@property(nonatomic,copy) NSString *begin_num;
@property(nonatomic,copy) NSString *gift_num;
@property(nonatomic,copy) NSString *gift_type;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *sale_goods;

@end

@interface GXConfirmOrderGoods : NSObject

@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *stock;
@property(nonatomic,copy) NSString *control_type;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *cart_num;
@property(nonatomic,copy) NSString *freight_template_id;
@property(nonatomic,copy) NSString *specs_attrs;
@property(nonatomic,copy) NSString *sku_id;
@property(nonatomic,copy) NSString *is_try;
@property(nonatomic,copy) NSString *provider_uid;
@property(nonatomic,copy) NSString *freight;
@property(nonatomic,copy) NSString *totalFreight;
@property(nonatomic,copy) NSString *totalPrice;
@property(nonatomic,copy) NSString *actTotalPrice;

@property(nonatomic,copy) NSString *brand_id;
@property(nonatomic,copy) NSString *logistics_com_id;
@property(nonatomic,copy) NSString *goods_area_id;
@property(nonatomic,copy) NSString *sale_id;
@property(nonatomic,copy) NSString *is_gift_rule;
@property(nonatomic,copy) NSString *brand_name;
@property(nonatomic,copy) NSString *goods_act_amount;
@end

NS_ASSUME_NONNULL_END
