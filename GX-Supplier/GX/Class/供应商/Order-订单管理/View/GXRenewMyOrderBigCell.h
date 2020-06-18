//
//  GXRenewMyOrderBigCell.h
//  GX
//
//  Created by huaxin-01 on 2020/6/18.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMyOrder,GXMyRefund;
typedef void(^cellClickedCall)(void);
@interface GXRenewMyOrderBigCell : UITableViewCell
/* 订单状态 1-5*/
@property(nonatomic,assign) NSInteger status;
/* 我的订单 */
@property (nonatomic, strong) GXMyOrder *myOrder;
/* 我的售后订单 */
@property (nonatomic, strong) GXMyRefund *myRefund;
/* cell点击 */
@property (nonatomic, copy) cellClickedCall cellClickedCall;
@end

NS_ASSUME_NONNULL_END
