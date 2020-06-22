//
//  GXMyOrderHeader.h
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMyOrder,GXMyRefund,GXGiftGoods;
@interface GXMyOrderHeader : UIView
/* 订单 */
@property(nonatomic,strong) GXMyOrder *order;
/* 退款 */
@property(nonatomic,strong) GXMyRefund *refund;
/* 赠品订单 */
@property (nonatomic, strong) GXGiftGoods *giftGoods;
@end

NS_ASSUME_NONNULL_END
