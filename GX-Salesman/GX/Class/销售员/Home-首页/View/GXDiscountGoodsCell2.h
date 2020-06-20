//
//  GXDiscountGoodsCell2.h
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GYHomeDiscount;
@interface GXDiscountGoodsCell2 : UICollectionViewCell
/* 必抢 */
@property(nonatomic,strong) GYHomeDiscount *discount;
@property (weak, nonatomic) IBOutlet UIView *bgContentView;

@end

NS_ASSUME_NONNULL_END
