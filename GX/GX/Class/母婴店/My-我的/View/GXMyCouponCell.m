//
//  GXMyCouponCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMyCouponCell.h"
#import "GXMyCoupon.h"

@interface GXMyCouponCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coupon_img;
@property (weak, nonatomic) IBOutlet UILabel *coupon_full;
@property (weak, nonatomic) IBOutlet UILabel *coupon_amount;
@property (weak, nonatomic) IBOutlet UILabel *coupon_type;
@property (weak, nonatomic) IBOutlet UILabel *coupon_time;
@property (weak, nonatomic) IBOutlet UIButton *get_coupon;

@end
@implementation GXMyCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCoupon:(GXMyCoupon *)coupon
{
    _coupon = coupon;
    
    self.coupon_amount.text = [NSString stringWithFormat:@"￥%@",_coupon.coupon_amount];
    self.coupon_full.text = _coupon.coupon_name;
    if ([_coupon.provider_uid isEqualToString:@"0"]) {
        self.coupon_type.text = @"全店通用";
    }else{
        self.coupon_type.text = _coupon.shop_name;
    }
    self.coupon_time.text = [NSString stringWithFormat:@"有效期限：%@",_coupon.deadline];
    
    if (_coupon.seaType == 1) {
        self.coupon_img.image = HXGetImage(@"优惠券1");
        self.coupon_amount.textColor = HXControlBg;
        self.coupon_full.textColor = [UIColor blackColor];
        self.coupon_type.textColor = HXControlBg;
        self.coupon_time.textColor = UIColorFromRGB(0x999999);
        self.get_coupon.hidden = NO;
    }else if (_coupon.seaType == 2) {
        self.coupon_img.image = HXGetImage(@"优惠券1");
        self.coupon_amount.textColor = HXControlBg;
        self.coupon_full.textColor = [UIColor blackColor];
        self.coupon_type.textColor = HXControlBg;
        self.coupon_time.textColor = UIColorFromRGB(0x999999);
        self.get_coupon.hidden = YES;
    }else{
        self.coupon_img.image = HXGetImage(@"优惠券-灰色");
        self.coupon_amount.textColor = UIColorFromRGB(0x999999);
        self.coupon_full.textColor = UIColorFromRGB(0x999999);
        self.coupon_type.textColor = UIColorFromRGB(0x999999);
        self.coupon_time.textColor = UIColorFromRGB(0x999999);
        self.get_coupon.hidden = YES;
    }
}
- (IBAction)takeCouponClicked:(UIButton *)sender {
    if (self.getCouponCall) {
        self.getCouponCall();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
