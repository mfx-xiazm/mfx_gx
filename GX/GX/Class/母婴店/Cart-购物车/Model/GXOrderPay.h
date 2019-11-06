//
//  GXOrderPay.h
//  GX
//
//  Created by 夏增明 on 2019/11/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GXPayAccount;
@interface GXOrderPay : NSObject
@property(nonatomic,copy) NSString *oid;
@property(nonatomic,copy) NSString *order_no;
@property(nonatomic,copy) NSString *create_time;
@property(nonatomic,copy) NSString *order_num;
@property(nonatomic,copy) NSString *pay_amount;
@property(nonatomic,copy) NSString *cover_img;
/* 支付倒计时 */
@property(nonatomic,assign) NSInteger countDown;
@property(nonatomic,strong) GXPayAccount *account_data;

@end

@interface GXPayAccount : NSObject
@property(nonatomic,copy) NSString *set_id;
@property(nonatomic,copy) NSString *set_type;
@property(nonatomic,copy) NSString *set_val;
@property(nonatomic,copy) NSString *set_val2;
@property(nonatomic,copy) NSString *set_val3;
@property(nonatomic,copy) NSString *set_val4;

@end
NS_ASSUME_NONNULL_END
