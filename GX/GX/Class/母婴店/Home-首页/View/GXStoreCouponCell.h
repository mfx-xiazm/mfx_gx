//
//  GXStoreCouponCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXStoreCoupons;
@interface GXStoreCouponCell : UICollectionViewCell
/* 优惠券 */
@property(nonatomic,strong) GXStoreCoupons *coupon;
@property (weak, nonatomic) IBOutlet UIImageView *coupon_bg_img;

@end

NS_ASSUME_NONNULL_END
