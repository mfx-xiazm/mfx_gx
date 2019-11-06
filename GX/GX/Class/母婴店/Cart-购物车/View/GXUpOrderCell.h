//
//  GXUpOrderCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXConfirmOrderData;
typedef void(^chooseCouponCall)(void);
@interface GXUpOrderCell : UITableViewCell
/* 商品 */
@property(nonatomic,strong) GXConfirmOrderData *orderData;
/* 点击 */
@property(nonatomic,copy) chooseCouponCall chooseCouponCall;
@end

NS_ASSUME_NONNULL_END
