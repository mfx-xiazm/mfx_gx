//
//  GXMarketTrendVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXMarketTrendVC : HXBaseViewController
/* 默认选中的索引 */
@property(nonatomic,assign) NSInteger selectIndex;
/* 图片 */
@property(nonatomic,copy) NSString *left_trend_img;
/* 图片 */
@property(nonatomic,copy) NSString *right_trend_img;
@end

NS_ASSUME_NONNULL_END
