//
//  GXDiscountGoodsCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GYHomeDiscount,GXDayDiscount;
@interface GXDiscountGoodsCell : UICollectionViewCell
/* 抢购 */
@property(nonatomic,strong) GYHomeDiscount *discount;
/* 抢购 */
@property(nonatomic,strong) GXDayDiscount *dayDiscount;
@end

NS_ASSUME_NONNULL_END
