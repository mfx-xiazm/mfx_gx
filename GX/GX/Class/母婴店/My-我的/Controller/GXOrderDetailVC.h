//
//  GXOrderDetailVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^orderHandleCall)(NSInteger type);
@interface GXOrderDetailVC : HXBaseViewController
/* 订单id */
@property(nonatomic,copy) NSString *oid;
/* 退款id */
@property(nonatomic,copy) NSString *refund_id;
/* 订单操作  0取消订单 1支付订单 2申请退款 3确认收货 4评价 5已删除 6已上传打款凭证*/
@property(nonatomic,copy) orderHandleCall orderHandleCall;
@end

NS_ASSUME_NONNULL_END
