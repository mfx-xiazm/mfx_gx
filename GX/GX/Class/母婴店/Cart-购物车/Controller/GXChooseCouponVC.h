//
//  GXChooseCouponVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class GXMyCoupon;
typedef void(^getUseCouponCall)(GXMyCoupon * _Nullable coupon);
@interface GXChooseCouponVC : HXBaseViewController
/* 店铺id 为0表示平台的优惠券 */
@property(nonatomic,copy) NSString *provider_uid;
/* 店铺下商品总价格 如果是平台的话则是所有的店铺的商品的价格总和 */
@property(nonatomic,copy) NSString *price_amount;
/* 店铺名字 */
@property(nonatomic,copy) NSString *shop_name;
/* 选择的优惠券 */
@property(nonatomic,strong) GXMyCoupon *selectCoupon;
/* 确定 */
@property(nonatomic,copy) getUseCouponCall getUseCouponCall;
@end

NS_ASSUME_NONNULL_END
