//
//  GXPartnerDataCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXPartnerDataCell.h"
#import "GXMyBusiness.h"

@interface GXPartnerDataCell ()
@property (weak, nonatomic) IBOutlet UILabel *title_name;
@property (weak, nonatomic) IBOutlet UILabel *year_amount;
@property (weak, nonatomic) IBOutlet UILabel *month_amount;

@end
@implementation GXPartnerDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setMyBusiness:(GXMyBusiness *)myBusiness
{
    _myBusiness = myBusiness;
    self.year_amount.text = [NSString stringWithFormat:@"￥%@",_myBusiness.year_pay_amount];
    self.month_amount.text = [NSString stringWithFormat:@"￥%@",_myBusiness.month_pay_amount];

}
-(void)setBrandBusiness:(GXMyBrandBusiness *)brandBusiness
{
    _brandBusiness = brandBusiness;
    
    self.title_name.text = _brandBusiness.brand_name;
    self.year_amount.text = [NSString stringWithFormat:@"￥%@",_brandBusiness.year_pay_amount];
    self.month_amount.text = [NSString stringWithFormat:@"￥%@",_brandBusiness.month_pay_amount];
}
-(void)setCateBusiness:(GXMyCataBusiness *)cateBusiness
{
    _cateBusiness = cateBusiness;
    self.title_name.text = _cateBusiness.catalog_name;
    self.year_amount.text = [NSString stringWithFormat:@"￥%@",_cateBusiness.year_pay_amount];
    self.month_amount.text = [NSString stringWithFormat:@"￥%@",_cateBusiness.month_pay_amount];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
