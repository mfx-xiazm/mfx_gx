//
//  GXConfirmOrder.h
//  GX
//
//  Created by 夏增明 on 2019/11/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMyAddress,GXConfirmOrderData,GXConfirmOrderGoods,GXMyCoupon;
@interface GXConfirmOrder : NSObject
/* 地址 */
@property(nonatomic,strong) GXMyAddress *defaultAddress;
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
/// 未加运费的不含商家优惠的总价格
@property(nonatomic,copy) NSString *shopActTotalPrice;
/// 加了运费的不含商家优惠的总价格
@property(nonatomic,copy) NSString *shopActTotalAmount;
/// 运费的总价格
@property(nonatomic,copy) NSString *shopActTotalFreight;
@property(nonatomic,strong) NSArray<GXConfirmOrderGoods *> *goods;
@property(nonatomic,strong) NSArray<GXMyCoupon *> *shopCouponData;
@property(nonatomic,strong) GXMyCoupon * _Nullable selectedCoupon;

@end

@interface GXConfirmOrderGoods : NSObject

@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *stock;
@property(nonatomic,copy) NSString *control_type;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *cart_num;
@property(nonatomic,copy) NSString *logistics_com_id;
@property(nonatomic,copy) NSString *specs_attrs;
@property(nonatomic,copy) NSString *sku_id;
@property(nonatomic,copy) NSString *is_try;
@property(nonatomic,copy) NSString *provider_uid;
@property(nonatomic,copy) NSString *freight;
@property(nonatomic,copy) NSString *totalFreight;
@property(nonatomic,copy) NSString *totalPrice;
@property(nonatomic,copy) NSString *actTotalPrice;

@end

NS_ASSUME_NONNULL_END
