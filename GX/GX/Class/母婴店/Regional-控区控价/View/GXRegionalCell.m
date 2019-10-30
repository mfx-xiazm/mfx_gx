//
//  GXRegionalCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXRegionalCell.h"
#import "GXGoodBrand.h"
#import "GXRegional.h"

@interface GXRegionalCell ()
@property (weak, nonatomic) IBOutlet UIImageView *brand_img;

@end
@implementation GXRegionalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setBrand:(GXGoodBrand *)brand
{
    _brand = brand;
    [self.brand_img sd_setImageWithURL:[NSURL URLWithString:_brand.brand_img]];
}
-(void)setRtry:(GXRegionalTry *)rtry
{
    _rtry = rtry;
    [self.brand_img sd_setImageWithURL:[NSURL URLWithString:_rtry.try_cover]];
}
-(void)setWeek:(GXRegionalWeekNewer *)week
{
    _week = week;
    [self.brand_img sd_setImageWithURL:[NSURL URLWithString:_week.week_newer]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
