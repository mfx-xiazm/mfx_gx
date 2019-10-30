//
//  GXHomePushCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXHomePushCell.h"
#import "GXHomeData.h"
#import "GXRegional.h"

@implementation GXHomePushCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setBanner:(GYHomeBanner *)banner
{
    _banner = banner;
    [self.contentImage sd_setImageWithURL:[NSURL URLWithString:_banner.adv_img]];
}
-(void)setRegional:(GYHomeRegional *)regional
{
    _regional = regional;
    [self.contentImage sd_setImageWithURL:[NSURL URLWithString:_regional.cover_img]];
}
-(void)setMarketTrend:(GYHomeMarketTrend *)marketTrend
{
    _marketTrend = marketTrend;
    [self.contentImage sd_setImageWithURL:[NSURL URLWithString:_marketTrend.img]];
}
-(void)setBrand:(GYHomeBrand *)brand
{
    _brand = brand;
    [self.contentImage sd_setImageWithURL:[NSURL URLWithString:_brand.cover_img]];
}
-(void)setActivity:(GYHomeActivity *)activity
{
    _activity = activity;
    [self.contentImage sd_setImageWithURL:[NSURL URLWithString:_activity.cover_img]];
}
-(void)setRegionalBanner:(GXRegionalBanner *)regionalBanner
{
    _regionalBanner = regionalBanner;
    [self.contentImage sd_setImageWithURL:[NSURL URLWithString:_regionalBanner.adv_img]];
}
@end
