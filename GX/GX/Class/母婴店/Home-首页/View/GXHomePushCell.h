//
//  GXHomePushCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GYHomeBanner,GYHomeRegional,GYHomeMarketTrend,GYHomeBrand,GYHomeActivity,GXRegionalBanner;
@interface GXHomePushCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;
/* banner */
@property(nonatomic,strong) GYHomeBanner *banner;
/* 控区控价 */
@property(nonatomic,strong) GYHomeRegional *regional;
/* 通货行情 */
@property(nonatomic,strong) GYHomeMarketTrend *marketTrend;
/* 品牌 */
@property(nonatomic,strong) GYHomeBrand *brand;
/* 活动 */
@property(nonatomic,strong) GYHomeActivity *activity;
/* banner */
@property(nonatomic,strong) GXRegionalBanner *regionalBanner;
@end

NS_ASSUME_NONNULL_END
