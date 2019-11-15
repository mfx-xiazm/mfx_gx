//
//  GXAllCommentVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class GXGoodsDetail;
@interface GXAllCommentVC : HXBaseViewController
/* 商品id */
@property(nonatomic,copy) NSString *goods_id;
/* 评价数量 */
@property(nonatomic,copy) NSString *evaCount;
/* 商品详情 */
@property(nonatomic,strong) GXGoodsDetail *goodsDetail;
@end

NS_ASSUME_NONNULL_END
