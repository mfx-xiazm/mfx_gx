//
//  GXStoreCouponCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXStoreCouponCell.h"
#import "GXStore.h"

@interface GXStoreCouponCell ()
@property (weak, nonatomic) IBOutlet UILabel *coupon_amount;
@property (weak, nonatomic) IBOutlet UILabel *full_amount;
@property (weak, nonatomic) IBOutlet UILabel *coupon_name;
@property (weak, nonatomic) IBOutlet UILabel *expire_time;
@end
@implementation GXStoreCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCoupon:(GXStoreCoupons *)coupon
{
    _coupon = coupon;
    self.coupon_amount.text = [NSString stringWithFormat:@"  %@  ",_coupon.coupon_amount];
    self.full_amount.text = [NSString stringWithFormat:@"满%@使用",_coupon.fulfill_amount];
    self.coupon_name.text = @"优惠券";
    self.expire_time.text = [NSString stringWithFormat:@"%@",_coupon.expire_time];
}
@end
