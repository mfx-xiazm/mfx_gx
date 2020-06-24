//
//  GXMyRefund.h
//  GX
//
//  Created by 夏增明 on 2019/11/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GYMyRefundGoods,GYMyRefundAddress,GXMyRefundRecommend,GXMyRefundProvider;
@interface GXMyRefund : NSObject
@property(nonatomic,copy) NSString *refund_id;
@property(nonatomic,copy) NSString *oid;
@property(nonatomic,copy) NSString *order_no;
/** 1等待供应商审核；2等待平台审核；3退款成功；4退款驳回 5供应商同意 6供应商不同意 */
@property(nonatomic,copy) NSString *refund_status;
@property(nonatomic,copy) NSString *refund_img;
@property(nonatomic,copy) NSString *refund_time;
@property(nonatomic,copy) NSString *pay_amount;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *goods_num;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *specs_attrs;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *control_type;
@property(nonatomic,copy) NSString *shop_name;

@property(nonatomic,copy) NSString *total_reduce_amount;
@property(nonatomic,copy) NSString *total_pay_amount;
@property(nonatomic,copy) NSString *pay_type;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *provider_uid;
@property(nonatomic,copy) NSString *pay_time;
@property(nonatomic,copy) NSString *order_freight_amount;
@property(nonatomic,copy) NSString *order_price_amount;
@property(nonatomic,copy) NSString *create_time;
@property(nonatomic,copy) NSString *reject_reason;
@property(nonatomic,copy) NSString *logistics_com_id;
// 订单号可能存在多个
@property(nonatomic,copy) NSString *logistics_no;
@property(nonatomic,copy) NSArray *logistics_nos;
@property(nonatomic,copy) NSString *logistics_com_name;
@property(nonatomic,copy) NSString *driver_phone;
@property(nonatomic,copy) NSString *receiver;
@property(nonatomic,copy) NSString *receiver_phone;
@property(nonatomic,copy) NSString *area_name;
@property(nonatomic,copy) NSString *address_detail;
@property(nonatomic,copy) NSString *trade_no;
@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSString *logistics_title;
@property(nonatomic,copy) NSString *order_coupon_amount;
@property(nonatomic,copy) NSString *provider_no;
@property(nonatomic,copy) NSString *username;
@property(nonatomic,copy) NSString *saleman_code;
@property(nonatomic,copy) NSString *send_freight_type;
/* 是退款详情数据 */
@property(nonatomic,assign) BOOL isRefundDetail;
@property(nonatomic,strong) NSArray<GXMyRefundProvider *> *provider;
//@property(nonatomic,strong) NSArray<GYMyRefundGoods *> *goods;
@property(nonatomic,strong) NSArray<GXMyRefundRecommend *> *goods_recommend;

@property(nonatomic,strong) GYMyRefundAddress *address;

@end

@interface GXMyRefundProvider : NSObject
@property(nonatomic,copy) NSString *provider_uid;
@property(nonatomic,copy) NSString *shop_name;
@property(nonatomic,copy) NSString *provider_no;
@property(nonatomic,strong) NSArray<GYMyRefundGoods *> *goods;
@end

@interface GYMyRefundGoods : NSObject
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *goods_num;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *specs_attrs;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *freight_amount;
@property(nonatomic,copy) NSString *price_amount;
@property(nonatomic,copy) NSString *control_type;

@end

@interface GYMyRefundAddress : NSObject
@property(nonatomic,copy) NSString *receiver;
@property(nonatomic,copy) NSString *receiver_phone;
@property(nonatomic,copy) NSString *receiver_address;

@end

@interface GXMyRefundRecommend : NSObject
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
