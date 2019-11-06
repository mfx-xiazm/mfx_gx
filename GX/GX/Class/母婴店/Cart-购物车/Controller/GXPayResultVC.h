//
//  GXPayResultVC.h
//  GX
//
//  Created by 夏增明 on 2019/11/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class GXOrderPay;
@interface GXPayResultVC : HXBaseViewController
/* 订单信息 */
@property(nonatomic,strong) GXOrderPay *orderPay;
/* 支付方式 */
@property(nonatomic,copy) NSString *pay_type;
@end

NS_ASSUME_NONNULL_END
