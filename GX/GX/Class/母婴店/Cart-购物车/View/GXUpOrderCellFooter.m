//
//  GXUpOrderCellFooter.m
//  GX
//
//  Created by huaxin-01 on 2020/6/15.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXUpOrderCellFooter.h"
#import "GXConfirmOrder.h"
#import "GXMyCoupon.h"

@interface GXUpOrderCellFooter ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *couponAmount;
@property (weak, nonatomic) IBOutlet UITextField *remark;
@property (weak, nonatomic) IBOutlet UILabel *goodsNum;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *payAmount;
@end
@implementation GXUpOrderCellFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.remark.delegate = self;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField hasText]) {
        _orderData.shopGoodsRemark = textField.text;
    }else{
        _orderData.shopGoodsRemark = @"";
    }
}
- (IBAction)couponClicked:(UIButton *)sender {
    if (self.couponCall) {
        self.couponCall();
    }
}
-(void)setOrderData:(GXConfirmOrderData *)orderData
{
    _orderData = orderData;
    
    if ([_orderData.provider_uid isEqualToString:@"0"]) {// 平台自营
        self.couponView.hidden = YES;
        self.couponViewHeight.constant = 0.f;
        self.couponAmount.text = @"";
        
        self.payAmount.text = [NSString stringWithFormat:@"￥%.2f",[_orderData.shopActTotalAmount floatValue]];
    }else{
        self.couponView.hidden = NO;
        self.couponViewHeight.constant = 40.f;
        
        // shopActTotalAmount - 优惠
        if (_orderData.selectedCoupon) {// 存在优惠
            self.payAmount.text = [NSString stringWithFormat:@"￥%.2f",[_orderData.shopActTotalAmount floatValue] - [_orderData.selectedCoupon.coupon_amount floatValue]];
            self.couponAmount.text = [NSString stringWithFormat:@"-￥%@",_orderData.selectedCoupon.coupon_amount];
            self.couponAmount.textColor = UIColorFromRGB(0xEC142D);
        }else{
           self.payAmount.text = [NSString stringWithFormat:@"￥%.2f",[_orderData.shopActTotalAmount floatValue]];
            if (_orderData.shopCouponData && _orderData.shopCouponData.count) {
                self.couponAmount.text = @"可用优惠券";
                self.couponAmount.textColor = UIColorFromRGB(0xEC142D);
            }else{
                self.couponAmount.text = @"无可用优惠券";
                self.couponAmount.textColor = [UIColor lightGrayColor];
            }
        }
    }
    self.remark.text = _orderData.shopGoodsRemark;
    self.goodsNum.text = [NSString stringWithFormat:@"共%lu件商品",(unsigned long)_orderData.goods.count];
}
@end
