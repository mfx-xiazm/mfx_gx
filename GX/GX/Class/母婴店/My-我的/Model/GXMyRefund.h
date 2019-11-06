//
//  GXMyRefund.h
//  GX
//
//  Created by 夏增明 on 2019/11/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GYMyRefundGoods,GYMyRefundAddress;
@interface GXMyRefund : NSObject
@property(nonatomic,copy) NSString *refund_id;
@property(nonatomic,copy) NSString *oid;
@property(nonatomic,copy) NSString *order_no;
/** 1等待经销商审核；2等待平台审核；3退款成功；4退款驳回 5经销商同意 6经销商不同意 */
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

@property(nonatomic,copy) NSString *pay_type;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *provider_uid;
@property(nonatomic,copy) NSString *pay_time;
@property(nonatomic,copy) NSString *order_freight_amount;
@property(nonatomic,copy) NSString *order_price_amount;
@property(nonatomic,copy) NSString *create_time;
@property(nonatomic,copy) NSString *reject_reason;
@property(nonatomic,copy) NSString *logistics_com_id;
@property(nonatomic,copy) NSString *logistics_no;
@property(nonatomic,copy) NSString *logistics_com_name;
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

@property(nonatomic,strong) NSArray<GYMyRefundGoods *> *goods;

@property(nonatomic,strong) GYMyRefundAddress *address;

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

NS_ASSUME_NONNULL_END
