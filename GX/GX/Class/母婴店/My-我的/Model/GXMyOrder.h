//
//  GXMyOrder.h
//  GX
//
//  Created by 夏增明 on 2019/11/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMyOrderGoods,GXMyOrderRecommend,GXMyOrderProvider,GXMyOrderRebate;
@interface GXMyOrder : NSObject
@property(nonatomic,copy) NSString *oid;
@property(nonatomic,copy) NSString *order_no;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *pay_type;
@property(nonatomic,copy) NSString *order_num;
@property(nonatomic,copy) NSString *order_freight_amount;
@property(nonatomic,copy) NSString *order_price_amount;
@property(nonatomic,copy) NSString *total_pay_amount;
@property(nonatomic,copy) NSString *pay_amount;
@property(nonatomic,copy) NSString *create_time;
@property(nonatomic,copy) NSString *area_name;
@property(nonatomic,copy) NSString *address_detail;
@property(nonatomic,copy) NSString *logistics_com_id;
// 订单号可能存在多个
@property(nonatomic,copy) NSString *logistics_no;
@property(nonatomic,copy) NSArray *logistics_nos;
@property(nonatomic,copy) NSString *logistics_com_name;
/**线下支付审核状态：1待上传打款凭证；2审核通过；3审核驳回。4上传打款凭证审核中；线上支付不需要审核逻辑*/
@property(nonatomic,copy) NSString *approve_status;
@property(nonatomic,copy) NSString *approve_time;
/** 1等待供应商审核；2等待平台审核；3退款成功；4退款驳回 5供应商同意 6供应商不同意 */
@property(nonatomic,copy) NSString *refund_status;
@property(nonatomic,copy) NSString *receiver;
@property(nonatomic,copy) NSString *receiver_phone;
@property(nonatomic,copy) NSString *pay_time;
@property(nonatomic,copy) NSString *reject_reason;
@property(nonatomic,copy) NSString *order_coupon_amount;
@property(nonatomic,copy) NSString *total_reduce_amount;
@property(nonatomic,copy) NSString *provider_uid;
@property(nonatomic,copy) NSString *provider_no;
@property(nonatomic,copy) NSString *username;
@property(nonatomic,copy) NSString *saleman_code;
@property(nonatomic,copy) NSString *driver_phone;
@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSString *logistics_title;
@property(nonatomic,copy) NSString *send_freight_type;
@property(nonatomic,copy) NSString *isRefund;
@property(nonatomic,copy) NSString *gift_order_id;
/* 是详情数据 */
@property(nonatomic,assign) BOOL isDetailOrder;
@property(nonatomic,strong) NSArray<GXMyOrderProvider *> *provider;
@property(nonatomic,strong) NSArray<GXMyOrderRecommend *> *goods_recommend;

@end

@interface GXMyOrderProvider : NSObject
@property(nonatomic,copy) NSString *provider_uid;
@property(nonatomic,copy) NSString *shop_name;
@property(nonatomic,copy) NSString *provider_no;
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

@property(nonatomic,strong) NSArray<GXMyOrderGoods *> *goods;
@property(nonatomic,strong) NSArray<GXMyOrderRebate *> *brand_rebate;
@end

@interface GXMyOrderRebate : NSObject
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

@interface GXMyOrderGoods : NSObject
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *goods_num;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *specs_attrs;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *price_amount;
@property(nonatomic,copy) NSString *control_type;
/** 1等待供应商审核；2等待平台审核；3退款成功；4退款驳回 5供应商同意 6供应商不同意 */
@property(nonatomic,copy) NSString *refund_status;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *freight_amount;
@property(nonatomic,copy) NSString *totalPrice;
@property(nonatomic,copy) NSString *order_goods_desc;
@end

@interface GXMyOrderRecommend : NSObject
@property(nonatomic,copy) NSString *home_set_id;
@property(nonatomic,copy) NSString *ref_id;
@property(nonatomic,copy) NSString *set_cover_img;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *control_type;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *brand_id;
@property(nonatomic,copy) NSString *suggest_price;
@property(nonatomic,copy) NSString *min_price;
@property(nonatomic,copy) NSString *max_price;

@end

NS_ASSUME_NONNULL_END
