//
//  GXApplyRefund.h
//  GX
//
//  Created by huaxin-01 on 2020/6/24.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GXApplyRefundReason;
@interface GXApplyRefund : NSObject
@property(nonatomic,assign) NSInteger goods_num;
@property(nonatomic,assign) NSInteger refund_num;
@property(nonatomic,copy) NSString *enable_refund_num;//可退数量
@property(nonatomic,copy) NSString *order_price_amount;
@property(nonatomic,copy) NSString *pay_amount;
@property(nonatomic,copy) NSString *order_freight_amount;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *specs_attrs;
@property (nonatomic, strong) NSArray<GXApplyRefundReason *> *orderReason;
@end

@interface GXApplyRefundReason : NSObject
@property(nonatomic,copy) NSString *set_val2;
@end
NS_ASSUME_NONNULL_END
