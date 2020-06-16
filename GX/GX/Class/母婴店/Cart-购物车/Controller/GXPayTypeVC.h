//
//  GXPayTypeVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^paySuccessCall)(void);
@interface GXPayTypeVC : HXBaseViewController
/* 订单号 */
@property(nonatomic,copy) NSString *order_no;
/* 订单id */
@property(nonatomic,copy) NSString *oid;
/* 支付结果回调 */
@property (nonatomic, copy) paySuccessCall paySuccessCall;
/* 订单列表y跳转 */
@property(nonatomic,assign) BOOL isOrderPush;
@end

NS_ASSUME_NONNULL_END
