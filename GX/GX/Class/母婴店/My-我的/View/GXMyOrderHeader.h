//
//  GXMyOrderHeader.h
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMyOrder,GXMyRefund,GXSalerOrder;
@interface GXMyOrderHeader : UIView
/* 订单 */
@property(nonatomic,strong) GXMyOrder *order;
/* 退款 */
@property(nonatomic,strong) GXMyRefund *refund;
/* 销售员订单 */
@property(nonatomic,strong) GXSalerOrder *salerOrder;
@end

NS_ASSUME_NONNULL_END
