//
//  GXMyOrderFooter.h
//  GX
//
//  Created by huaxin-01 on 2020/6/24.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMyOrderProvider,GXMyRefundProvider;
@interface GXMyOrderFooter : UIView
/* 订单 */
@property(nonatomic,strong) GXMyOrderProvider *orderProvider;
/* 退款 */
@property(nonatomic,strong) GXMyRefundProvider *refundProvider;
@end

NS_ASSUME_NONNULL_END
