//
//  GXGoodsDetailVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXGoodsDetailVC : HXBaseViewController
/* 商品id */
@property(nonatomic,copy) NSString *goods_id;
/* 每日必抢id 常规商品和控区控价商品无该字段 则不需要传 */
@property(nonatomic,copy) NSString *rushbuy_id;
@end

NS_ASSUME_NONNULL_END
