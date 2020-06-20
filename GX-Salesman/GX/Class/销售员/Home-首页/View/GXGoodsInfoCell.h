//
//  GXGoodsInfoCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXGoodsDetailParam;
@interface GXGoodsInfoCell : UITableViewCell
/* 商品信息 */
@property(nonatomic,strong) GXGoodsDetailParam *param;
@end

NS_ASSUME_NONNULL_END
