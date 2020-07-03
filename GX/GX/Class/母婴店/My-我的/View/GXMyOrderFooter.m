//
//  GXMyOrderFooter.m
//  GX
//
//  Created by huaxin-01 on 2020/6/24.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXMyOrderFooter.h"
#import "GXMyOrder.h"
#import <zhPopupController.h>
#import "GXRebateView.h"
#import "GXMyRefund.h"

@interface GXMyOrderFooter ()
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *totalFreight;
@property (weak, nonatomic) IBOutlet UILabel *rebateAmount;
@property (weak, nonatomic) IBOutlet UILabel *rebateText;
@property (weak, nonatomic) IBOutlet UILabel *orderDesc;
@property (nonatomic, strong) zhPopupController *sharePopVC;

@end
@implementation GXMyOrderFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setOrderProvider:(GXMyOrderProvider *)orderProvider
{
    _orderProvider = orderProvider;
    
    self.totalPrice.text = [NSString stringWithFormat:@"%.2f",[_orderProvider.shopTotalPrice floatValue]];
    self.totalFreight.text = [NSString stringWithFormat:@"%.2f",[_orderProvider.shopActTotalFreight floatValue]];
    
    if (_orderProvider.brand_rebate && _orderProvider.brand_rebate.count) {
        GXMyOrderRebate *rebate = _orderProvider.brand_rebate.firstObject;
        self.rebateText.text = [rebate.rebate_percent floatValue]?[NSString stringWithFormat:@"返利%@%%",rebate.rebate_percent]:@"";
        self.rebateAmount.text = [NSString stringWithFormat:@"-%.2f",_orderProvider.shopRebateAmount?[_orderProvider.shopRebateAmount floatValue]:0];
    }else{
        self.rebateText.text = @"";
        self.rebateAmount.text = @"0.00";
    }
    
    GXMyOrderGoods *goods = _orderProvider.goods.firstObject;
    self.orderDesc.text = (goods.order_goods_desc && goods.order_goods_desc.length)?goods.order_goods_desc:@"无";
}
-(void)setRefundProvider:(GXMyRefundProvider *)refundProvider
{
    _refundProvider = refundProvider;
    
    self.totalPrice.text = [NSString stringWithFormat:@"%.2f",[_refundProvider.shopTotalPrice floatValue]];
    self.totalFreight.text = [NSString stringWithFormat:@"%.2f",[_refundProvider.shopActTotalFreight floatValue]];
    
    if (_refundProvider.brand_rebate && _refundProvider.brand_rebate.count) {
        GXMyRefundRebate *rebate = _refundProvider.brand_rebate.firstObject;
        self.rebateText.text = [rebate.rebate_percent floatValue]?[NSString stringWithFormat:@"返利%@%%",rebate.rebate_percent]:@"";
        self.rebateAmount.text = [NSString stringWithFormat:@"-%.2f",_refundProvider.shopRebateAmount?[_refundProvider.shopRebateAmount floatValue]:0];
    }else{
        self.rebateText.text = @"";
        self.rebateAmount.text = @"0.00";
    }
    
    GYMyRefundGoods *goods = _refundProvider.goods.firstObject;
    self.orderDesc.text = (goods.order_goods_desc && goods.order_goods_desc.length)?goods.order_goods_desc:@"无";
}
- (IBAction)giftRebateClicked:(UIButton *)sender {
    hx_weakify(self);
    if (_orderProvider) {
        if (_orderProvider.brand_rebate && _orderProvider.brand_rebate.count) {
            GXRebateView *rebateView = [GXRebateView loadXibView];
            rebateView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 400.f);
            rebateView.order_rebate = _orderProvider.brand_rebate;
            rebateView.closeClickedCall = ^{
                hx_strongify(weakSelf);
                [strongSelf.sharePopVC dismiss];
            };
            self.sharePopVC = [[zhPopupController alloc] initWithView:rebateView size:rebateView.bounds.size];
            self.sharePopVC.layoutType = zhPopupLayoutTypeBottom;
            [self.sharePopVC show];
        }
    }else{
        if (_refundProvider.brand_rebate && _refundProvider.brand_rebate.count) {
            GXRebateView *rebateView = [GXRebateView loadXibView];
            rebateView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 400.f);
            rebateView.refund_rebate = _refundProvider.brand_rebate;
            rebateView.closeClickedCall = ^{
                hx_strongify(weakSelf);
                [strongSelf.sharePopVC dismiss];
            };
            self.sharePopVC = [[zhPopupController alloc] initWithView:rebateView size:rebateView.bounds.size];
            self.sharePopVC.layoutType = zhPopupLayoutTypeBottom;
            [self.sharePopVC show];
        }
    }
}
@end
