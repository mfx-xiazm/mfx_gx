//
//  GXOrderDetailHeader.h
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMyOrder,GXMyRefund;
typedef void(^lookLogisCall)(void);
@interface GXOrderDetailHeader : UIView
/* 订单详情 */
@property(nonatomic,strong) GXMyOrder *orderDetail;
/* 退款详情 */
@property(nonatomic,strong) GXMyRefund *refundDetail;
/* 查看物流 */
@property(nonatomic,copy) lookLogisCall lookLogisCall;
@end

NS_ASSUME_NONNULL_END
