//
//  GXMyOrder.h
//  GX
//
//  Created by 夏增明 on 2019/11/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMyOrderGoods;
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
@property(nonatomic,copy) NSString *logistics_no;
@property(nonatomic,copy) NSString *logistics_com_name;
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
@property(nonatomic,copy) NSString *provider_no;
@property(nonatomic,copy) NSString *provider_uid;
@property(nonatomic,copy) NSString *username;
@property(nonatomic,copy) NSString *saleman_code;
@property(nonatomic,copy) NSString *driver_phone;
@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSString *logistics_title;
/* 是详情数据 */
@property(nonatomic,assign) BOOL isDetailOrder;
@property(nonatomic,strong) NSArray<GXMyOrderGoods *> *goods;

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

@end

NS_ASSUME_NONNULL_END
