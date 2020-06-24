//
//  GXPresellDetailVC.h
//  GX
//
//  Created by huaxin-01 on 2020/6/17.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^presellDownCall)(void);
@interface GXPresellDetailVC : HXBaseViewController
/* 预售id */
@property(nonatomic,copy) NSString *pre_sale_id;
/* 商品id */
@property (nonatomic, copy) NSString *goods_id;
/* 倒计时结束的回调 */
@property (nonatomic, copy) presellDownCall presellDownCall;
@end

NS_ASSUME_NONNULL_END
