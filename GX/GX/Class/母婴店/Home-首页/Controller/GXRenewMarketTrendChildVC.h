//
//  GXRenewMarketTrendChildVC.h
//  GX
//
//  Created by huaxin-01 on 2020/6/17.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXRenewMarketTrendChildVC : HXBaseViewController
/* 数据类型 1奶粉 2纸尿裤*/
@property(nonatomic,assign) NSInteger dataType;
@property (weak, nonatomic) UIScrollView *mainScrollView;
@end

NS_ASSUME_NONNULL_END
