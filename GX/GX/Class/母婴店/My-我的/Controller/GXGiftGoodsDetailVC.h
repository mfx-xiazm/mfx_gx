//
//  GXGiftGoodsDetailVC.h
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^statusChangeCall)(void);
@interface GXGiftGoodsDetailVC : HXBaseViewController
@property (nonatomic, copy) NSString *gift_order_id;
@property (nonatomic, copy) statusChangeCall statusChangeCall;
@end

NS_ASSUME_NONNULL_END
