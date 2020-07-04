//
//  GXSankPriceVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXSankPriceVC : HXBaseViewController
/* 商品id */
@property(nonatomic,copy) NSString *goods_id;
/* 1普通类型 2.预售类型 */
@property(nonatomic,copy) NSString *sale_type;
@end

NS_ASSUME_NONNULL_END
