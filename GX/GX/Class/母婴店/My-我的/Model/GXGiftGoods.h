//
//  GXGiftGoods.h
//  GX
//
//  Created by huaxin-01 on 2020/6/22.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXGiftGoods : NSObject
@property (nonatomic, copy) NSString *driver_phone;
@property (nonatomic, copy) NSString *gift_order_id;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *gift_name;
@property (nonatomic, copy) NSString *send_status;
@property (nonatomic, copy) NSString *area_name;
@property (nonatomic, copy) NSString *logistics_com_name;
@property (nonatomic, copy) NSString *gift_order_no;
@property (nonatomic, copy) NSString *address_detail;
@property (nonatomic, copy) NSString *provider_uid;
@property (nonatomic, copy) NSString *logistics_no;
@property (nonatomic, copy) NSString *gift_order_status;
@property (nonatomic, copy) NSString *gift_num;
@property (nonatomic, copy) NSString *logistics_com_id;
@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *provider_no;
@property (nonatomic, copy) NSString *receiver;
@property (nonatomic, copy) NSString *receiver_phone;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *shop_user_phone;
@property (nonatomic, copy) NSString *send_freight_type;
@property (nonatomic, copy) NSString *order_no;
@property (nonatomic, strong) NSArray *order_nos;//拆弹可能存在做个订单号

@end

NS_ASSUME_NONNULL_END
