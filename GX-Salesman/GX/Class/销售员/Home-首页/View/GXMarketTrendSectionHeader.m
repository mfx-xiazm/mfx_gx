//
//  GXMarketTrendSectionHeader.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMarketTrendSectionHeader.h"
#import "GXMarketTrend.h"

@interface GXMarketTrendSectionHeader()
@property (weak, nonatomic) IBOutlet UILabel *cateName;
@property (weak, nonatomic) IBOutlet UIImageView *cate_img;

@end
@implementation GXMarketTrendSectionHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)setSeries:(GXMarketTrendSeries *)series
{
    _series = series;
    self.cateName.text = _series.series_name;
    [self.cate_img sd_setImageWithURL:[NSURL URLWithString:_series.series_img]];
}
@end
