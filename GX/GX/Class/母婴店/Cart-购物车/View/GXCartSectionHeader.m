//
//  GXCartSectionHeader.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXCartSectionHeader.h"
#import "GXCartData.h"

@interface GXCartSectionHeader ()
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIButton *shopName;
@property (weak, nonatomic) IBOutlet UIButton *getCouponBtn;

@end
@implementation GXCartSectionHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCartData:(GXCartData *)cartData
{
    _cartData = cartData;
    self.checkBtn.selected = _cartData.is_checked;
    [self.shopName setTitle:_cartData.shop_name forState:UIControlStateNormal];
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
