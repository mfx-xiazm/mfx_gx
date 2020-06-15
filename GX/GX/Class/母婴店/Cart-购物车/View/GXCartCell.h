//
//  GXCartCell.h
//  GX
//
//  Created by huaxin-01 on 2020/6/15.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "MGSwipeTableCell.h"

NS_ASSUME_NONNULL_BEGIN
@class GXCartShopGoods;
typedef void(^cartHandleCall)(NSInteger index);
@interface GXCartCell : MGSwipeTableCell
/* 商品 */
@property(nonatomic,strong) GXCartShopGoods *goods;
/* 点击 */
@property(nonatomic,copy) cartHandleCall cartHandleCall;
@end

NS_ASSUME_NONNULL_END
