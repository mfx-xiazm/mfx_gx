//
//  GXRenewMyOrderCell.h
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GXMyOrderGoods,GXMyRefund,GYMyRefundGoods,GXConfirmOrderGoods,GXSalerOrder;
@interface GXRenewMyOrderCell : UITableViewCell
/* 商品 */
@property(nonatomic,strong) GXMyOrderGoods *goods;
/* 退款商品 */
@property(nonatomic,strong) GYMyRefundGoods *refundGoods;
/* 退款 */
@property(nonatomic,strong) GXMyRefund *refund;
/* 提交订单商品 */
@property(nonatomic,strong) GXConfirmOrderGoods *upGoods;
/* 销售员订单 */
@property(nonatomic,strong) GXSalerOrder *salerOrder;
@end

NS_ASSUME_NONNULL_END
