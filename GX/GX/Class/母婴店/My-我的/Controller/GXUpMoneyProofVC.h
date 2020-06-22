//
//  GXUpMoneyProofVC.h
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class GXMyOrderGoods;
typedef void(^upProofCall)(void);
@interface GXUpMoneyProofVC : HXBaseViewController
@property (nonatomic, copy) upProofCall upProofCall;
@property (nonatomic, copy) NSString *oid;
@property (nonatomic, strong) GXMyOrderGoods *goods;
@end

NS_ASSUME_NONNULL_END
