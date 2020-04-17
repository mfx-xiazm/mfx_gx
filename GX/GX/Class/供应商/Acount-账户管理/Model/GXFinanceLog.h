//
//  GXFinanceLog.h
//  GX
//
//  Created by 夏增明 on 2019/11/8.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GXLogOrder;
@interface GXFinanceLog : NSObject
@property(nonatomic,copy) NSString *finance_log_id;
@property(nonatomic,assign) NSInteger finance_log_type;
@property(nonatomic,copy) NSString *finance_log_desc;
@property(nonatomic,copy) NSString *amount;
@property(nonatomic,copy) NSString *finance_balance;
@property(nonatomic,copy) NSString *ref_id;
@property(nonatomic,copy) NSString *is_cashed;
@property(nonatomic,copy) NSString *create_time;
/* 订单 */
@property(nonatomic,strong) GXLogOrder *orderInfo;

@end

@interface GXLogOrder : NSObject
@property(nonatomic,copy) NSString *pay_amount;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *order_no;
@property(nonatomic,copy) NSString *oid;

@end

NS_ASSUME_NONNULL_END
