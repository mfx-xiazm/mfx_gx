//
//  GXPayTypeHeader.h
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GXOrderPay;
@interface GXPayTypeHeader : UIView
/* 订单信息 */
@property(nonatomic,strong) GXOrderPay *orderPay;
@end

NS_ASSUME_NONNULL_END
