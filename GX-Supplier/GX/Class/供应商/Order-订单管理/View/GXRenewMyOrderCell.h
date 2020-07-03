//
//  GXRenewMyOrderCell.h
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GXMyOrderGoods,GXMyRefund,GYMyRefundGoods,GXConfirmOrderGoods;
@interface GXRenewMyOrderCell : UITableViewCell
/* 商品 */
@property(nonatomic,strong) GXMyOrderGoods *goods;
/* 退款商品 */
@property(nonatomic,strong) GYMyRefundGoods *refundGoods;
/* 退款 */
@property(nonatomic,strong) GXMyRefund *refund;
/* 退款数量 */
@property(nonatomic,copy) NSString *return_num;
/* 退款金额 */
@property(nonatomic,copy) NSString *return_amount;
/* 提交订单商品 */
@property(nonatomic,strong) GXConfirmOrderGoods *upGoods;
@end

NS_ASSUME_NONNULL_END
