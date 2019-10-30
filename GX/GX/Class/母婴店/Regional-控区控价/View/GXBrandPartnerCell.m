//
//  GXBrandPartnerCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXBrandPartnerCell.h"
#import "GXGoodBrand.h"

@interface GXBrandPartnerCell ()
@property (weak, nonatomic) IBOutlet UIImageView *brand_logo;
@property (weak, nonatomic) IBOutlet UILabel *brand_name;
@property (weak, nonatomic) IBOutlet UILabel *sale_num;

@end
@implementation GXBrandPartnerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setBrand:(GXGoodBrand *)brand
{
    _brand = brand;
    [self.brand_logo sd_setImageWithURL:[NSURL URLWithString:_brand.brand_logo]];
    self.brand_name.text = _brand.brand_name;
    self.sale_num.text = [NSString stringWithFormat:@"本月交易金额：￥%@",_brand.total_amount];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
