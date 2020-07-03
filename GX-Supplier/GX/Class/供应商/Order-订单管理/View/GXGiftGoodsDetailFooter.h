//
//  GXGiftGoodsDetailFooter.h
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GXGiftGoods;
typedef void(^giftOrderNoCall)(void);
@interface GXGiftGoodsDetailFooter : UIView
@property (nonatomic, copy) giftOrderNoCall giftOrderNoCall;
/* 赠品订单 */
@property (nonatomic, strong) GXGiftGoods *giftGoods;
@end

NS_ASSUME_NONNULL_END
