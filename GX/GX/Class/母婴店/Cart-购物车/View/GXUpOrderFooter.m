//
//  GXUpOrderFooter.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXUpOrderFooter.h"
#import "GXConfirmOrder.h"
#import "GXMyCoupon.h"

@interface GXUpOrderFooter ()
@property (weak, nonatomic) IBOutlet UILabel *discount;
@property (weak, nonatomic) IBOutlet UILabel *couponAmount;

@end
@implementation GXUpOrderFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setConfirmOrder:(GXConfirmOrder *)confirmOrder
{
    _confirmOrder = confirmOrder;
    if (![_confirmOrder.discount isEqualToString:@"0"]) {
        self.discount.text = [NSString stringWithFormat:@"%@折 -%@",_confirmOrder.discount,_confirmOrder.discount_amount];
    }else {
        self.discount.text = @"无";
    }
    
    if (_confirmOrder.selectedPlatformCoupon) {
        self.couponAmount.text = [NSString stringWithFormat:@"-%@",_confirmOrder.selectedPlatformCoupon.coupon_amount];
    }else{
        self.couponAmount.text = @"";
    }
}
- (IBAction)couponClicked:(UIButton *)sender {
    if (self.getCouponCall) {
        self.getCouponCall();
    }
}

@end
