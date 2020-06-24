//
//  GXMyOrderHeader.h
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMyOrderProvider,GXMyRefundProvider,GXGiftGoods;
@interface GXMyOrderHeader : UIView
/* 订单 */
@property(nonatomic,strong) GXMyOrderProvider *orderProvider;
/* 退款 */
@property(nonatomic,strong) GXMyRefundProvider *refundProvider;
/* 赠品订单 */
@property (nonatomic, strong) GXGiftGoods *giftGoods;
@end

NS_ASSUME_NONNULL_END
