//
//  GXRenewMyOrderBigCellHeader.h
//  GX
//
//  Created by huaxin-01 on 2020/6/18.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMyOrder,GXMyRefund;
@interface GXRenewMyOrderBigCellHeader : UIView
/* 我的订单 */
@property (nonatomic, strong) GXMyOrder *myOrder;
/* 我的售后订单 */
@property (nonatomic, strong) GXMyRefund *myRefund;
@end
NS_ASSUME_NONNULL_END
