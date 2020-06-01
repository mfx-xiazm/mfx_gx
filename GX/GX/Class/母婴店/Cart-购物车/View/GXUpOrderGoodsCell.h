//
//  GXUpOrderGoodsCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMyOrderGoods,GXMyRefund,GYMyRefundGoods,GXConfirmOrderGoods;
@interface GXUpOrderGoodsCell : UITableViewCell
/* 商品 */
@property(nonatomic,strong) GXMyOrderGoods *goods;
/* 退款商品 */
@property(nonatomic,strong) GYMyRefundGoods *refundGoods;
/* 退款 */
@property(nonatomic,strong) GXMyRefund *refund;
/* 提交订单商品 */
@property(nonatomic,strong) GXConfirmOrderGoods *upGoods;
@end

NS_ASSUME_NONNULL_END
