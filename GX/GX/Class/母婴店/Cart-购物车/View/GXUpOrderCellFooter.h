//
//  GXUpOrderCellFooter.h
//  GX
//
//  Created by huaxin-01 on 2020/6/15.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXConfirmOrderData;
typedef void(^couponCall)(void);
@interface GXUpOrderCellFooter : UIView
/* 商品 */
@property(nonatomic,strong) GXConfirmOrderData *orderData;
/* 点击 */
@property(nonatomic,copy) couponCall couponCall;
@end

NS_ASSUME_NONNULL_END
