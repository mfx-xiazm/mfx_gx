//
//  GXMyOrderFooter.h
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMyOrder,GXMyRefund,GXSalerOrder;
typedef void(^orderHandleCall)(NSInteger index);
@interface GXMyOrderFooter : UIView
@property (weak, nonatomic) IBOutlet UIView *handleView;
/* 订单 */
@property(nonatomic,strong) GXMyOrder *order;
/* 退款 */
@property(nonatomic,strong) GXMyRefund *refund;
/* 订单 */
@property(nonatomic,strong) GXMyOrder *pOrder;
/* 退款 */
@property(nonatomic,strong) GXMyRefund *pRefund;
/* 操作 */
@property(nonatomic,copy) orderHandleCall orderHandleCall;
@end

NS_ASSUME_NONNULL_END
