//
//  GXUpOrderFooter.h
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXConfirmOrder;
typedef void(^getCouponCall)(void);
@interface GXUpOrderFooter : UIView
/* 点击 */
@property(nonatomic,copy) getCouponCall getCouponCall;
/* 订单 */
@property(nonatomic,strong) GXConfirmOrder *confirmOrder;
@end

NS_ASSUME_NONNULL_END
