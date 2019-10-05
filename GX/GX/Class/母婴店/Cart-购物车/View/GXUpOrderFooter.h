//
//  GXUpOrderFooter.h
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^getCouponCall)(void);
@interface GXUpOrderFooter : UIView
/* 点击 */
@property(nonatomic,copy) getCouponCall getCouponCall;
@end

NS_ASSUME_NONNULL_END
