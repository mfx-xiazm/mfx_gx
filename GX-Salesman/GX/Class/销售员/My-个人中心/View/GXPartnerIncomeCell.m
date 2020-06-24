//
//  GXPartnerIncomeCell.m
//  GX
//
//  Created by huaxin-01 on 2020/6/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXPartnerIncomeCell.h"
#import "GXPartnerIncome.h"

@interface GXPartnerIncomeCell()
@property (weak, nonatomic) IBOutlet UILabel *shop_name;
@property (weak, nonatomic) IBOutlet UILabel *a_mount;
@property (weak, nonatomic) IBOutlet UILabel *b_mount;

@end
@implementation GXPartnerIncomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setIncome:(GXPartnerIncome *)income
{
    _income = income;
    self.shop_name.text = _income.shop_name;
    self.a_mount.text = _income.a_mount;
    self.b_mount.text = _income.b_mount;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
