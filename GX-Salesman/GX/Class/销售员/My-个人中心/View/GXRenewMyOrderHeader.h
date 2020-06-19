//
//  GXRenewMyOrderHeader.h
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMyOrder,GXMyRefund,GXSalerOrder;
@interface GXRenewMyOrderHeader : UIView
/* 订单 */
@property(nonatomic,strong) GXMyOrder *order;
/* 退款 */
@property(nonatomic,strong) GXMyRefund *refund;
/* 销售员订单 */
@property(nonatomic,strong) GXSalerOrder *salerOrder;
@end

NS_ASSUME_NONNULL_END
