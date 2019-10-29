//
//  GXHomeData.m
//  GX
//
//  Created by 夏增明 on 2019/10/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXHomeData.h"

@implementation GXHomeData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"homeAdv":[GYHomeBanner class],
             @"home_rushbuy":[GYHomeDiscount class],
             @"home_control_price_brand":[GYHomeRegional class],
             @"currency_img":[GYHomeMarketTrend class],
             @"home_brand_goods":[GYHomeBrand class],
             @"home_select_material":[GYHomeActivity class],
             @"home_recommend_goods":[GYHomePushGoods class]
             };
}

@end

@implementation GYHomeBanner

@end

@implementation GYHomeTopCate

@end

@implementation GYHomeDiscount

@end

@implementation GYHomeRegional

@end

@implementation GYHomeMarketTrend

@end

@implementation GYHomeBrand

@end

@implementation GYHomeActivity

@end

@implementation GYHomePushGoods

@end
