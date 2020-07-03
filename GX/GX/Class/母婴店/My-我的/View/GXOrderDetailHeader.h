//
//  GXOrderDetailHeader.h
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMyOrder,GXMyRefund,GXGiftGoods;
typedef void(^lookLogisCall)(void);
typedef void(^lookGiftOrderCall)(void);
@interface GXOrderDetailHeader : UIView
/* 订单详情 */
@property(nonatomic,strong) GXMyOrder *orderDetail;
/* 退款详情 */
@property(nonatomic,strong) GXMyRefund *refundDetail;
/* 查看物流 */
@property(nonatomic,copy) lookLogisCall lookLogisCall;
/* 查看赠品订单 */
@property (nonatomic, copy) lookGiftOrderCall lookGiftOrderCall;
/* 赠品订单 */
@property (nonatomic, strong) GXGiftGoods *giftGoods;
@end

NS_ASSUME_NONNULL_END
