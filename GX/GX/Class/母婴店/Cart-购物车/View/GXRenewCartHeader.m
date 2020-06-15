//
//  GXRenewCartHeader.m
//  GX
//
//  Created by huaxin-01 on 2020/6/15.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXRenewCartHeader.h"
#import "GXCartData.h"

@interface GXRenewCartHeader ()
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIButton *shopName;
@property (weak, nonatomic) IBOutlet UIButton *getCouponBtn;
@end
@implementation GXRenewCartHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setCartData:(GXCartData *)cartData
{
    _cartData = cartData;
    self.checkBtn.selected = _cartData.is_checked;
    [self.shopName setTitle:[NSString stringWithFormat:@"  %@",_cartData.shop_name] forState:UIControlStateNormal];
    self.getCouponBtn.hidden = [_cartData.coupon isEqualToString:@"1"]?NO:YES;
}
- (IBAction)cartClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        sender.selected = !sender.selected;
        _cartData.is_checked = sender.isSelected;
    }
    if (self.cartHeaderClickedCall) {
        self.cartHeaderClickedCall(sender.tag);
    }
}
@end
