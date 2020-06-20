//
//  GXMyCouponChildVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXMyCouponChildVC : HXBaseViewController
/* 查询类型 1查询可以领取 2查询可使用 3查询已使用 */
@property(nonatomic,assign) NSInteger seaType;
@end

NS_ASSUME_NONNULL_END
