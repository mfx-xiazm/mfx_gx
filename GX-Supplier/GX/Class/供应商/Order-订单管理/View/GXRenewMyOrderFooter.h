//
//  GXRenewMyOrderFooter.h
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GXMyOrder,GXMyRefund;
typedef void(^orderHandleCall)(NSInteger index);
@interface GXRenewMyOrderFooter : UIView
@property (weak, nonatomic) IBOutlet UIView *handleView;
/* 订单 */
@property(nonatomic,strong) GXMyOrder *pOrder;
/* 退款 */
@property(nonatomic,strong) GXMyRefund *pRefund;
/* 操作 */
@property(nonatomic,copy) orderHandleCall orderHandleCall;
@end

NS_ASSUME_NONNULL_END
