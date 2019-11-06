//
//  GXGetCouponView.h
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXCartData;
typedef void(^closeViewCall)(void);
@interface GXGetCouponView : UIView
/* 店铺 */
@property(nonatomic,strong) GXCartData *cartData;
/* 关闭 */
@property(nonatomic,copy) closeViewCall closeViewCall;
@end

NS_ASSUME_NONNULL_END
