//
//  GXMyCouponCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMyCoupon;
typedef void(^getCouponCall)(void);
@interface GXMyCouponCell : UITableViewCell
/* 优惠券 */
@property(nonatomic,strong) GXMyCoupon *coupon;
/* 优惠券 */
@property(nonatomic,strong) GXMyCoupon *useCoupon;
/* 领取 */
@property(nonatomic,copy) getCouponCall getCouponCall;
@end

NS_ASSUME_NONNULL_END
