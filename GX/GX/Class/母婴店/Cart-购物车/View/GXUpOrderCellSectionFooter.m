//
//  GXUpOrderCellSectionFooter.m
//  GX
//
//  Created by huaxin-01 on 2020/6/15.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXUpOrderCellSectionFooter.h"
#import "GXConfirmOrder.h"
#import <zhPopupController.h>
#import "GXFullGiftView.h"
#import "GXRebateView.h"

@interface GXUpOrderCellSectionFooter ()
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *totalFreight;
@property (weak, nonatomic) IBOutlet UILabel *rebateAmount;
@property (weak, nonatomic) IBOutlet UILabel *gift_text;
@property (weak, nonatomic) IBOutlet UILabel *rebateText;
@property (nonatomic, strong) zhPopupController *sharePopVC;
@end
@implementation GXUpOrderCellSectionFooter
-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setOrderData:(GXConfirmOrderData *)orderData
{
    _orderData = orderData;

    self.totalPrice.text = [NSString stringWithFormat:@"￥%.2f",[_orderData.shopTotalPrice floatValue]];
    self.totalFreight.text = [NSString stringWithFormat:@"￥%.2f",[_orderData.shopActTotalFreight floatValue]];

    if (_orderData.gift_data && _orderData.gift_data.count) {
        NSMutableString *giftTxt = [NSMutableString string];
        for (GXConfirmGoodsGift *gift in _orderData.gift_data) {
            if ([gift.gift_type isEqualToString:@"1"]) {// 本品
                if (giftTxt.length) {
                   [giftTxt appendFormat:@"，%@",[NSString stringWithFormat:@"买%@赠%@",gift.begin_num,gift.gift_num]];
                }else{
                    [giftTxt appendFormat:@"%@",[NSString stringWithFormat:@"买%@赠%@",gift.begin_num,gift.gift_num]];
                }
            }else{// 其他
                if (giftTxt.length) {
                    [giftTxt appendFormat:@"\n%@",[NSString stringWithFormat:@"买%@搭赠%@%@",gift.begin_num,gift.gift_num,gift.goods_name]];
                }else{
                    [giftTxt appendFormat:@"%@",[NSString stringWithFormat:@"买%@搭赠%@%@",gift.begin_num,gift.gift_num,gift.goods_name]];
                }
            }
        }
        self.gift_text.text = giftTxt;
    }else{
        self.gift_text.text = @"无";
    }
    
    if (_orderData.brand_rebate && _orderData.brand_rebate.count) {
        GXConfirmBrandRebate *rebate = _orderData.brand_rebate.firstObject;
        self.rebateText.text = [NSString stringWithFormat:@"满%@元返%@%%",rebate.begin_price,rebate.rebate_percent];
        self.rebateAmount.text = [NSString stringWithFormat:@"-￥%.2f",_orderData.shopRebateAmount?[_orderData.shopRebateAmount floatValue]:0];
    }else{
        self.rebateText.text = @"";
        self.rebateAmount.text = @"￥0.00";
    }
}
- (IBAction)giftRebateClicked:(UIButton *)sender {
    hx_weakify(self);
    if (sender.tag == 1) {
        if (_orderData.gift_data && _orderData.gift_data.count) {
            GXFullGiftView *giftView = [GXFullGiftView loadXibView];
            giftView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 300.f);
            giftView.gift_data = _orderData.gift_data;
            giftView.closeClickedCall = ^{
                hx_strongify(weakSelf);
                [strongSelf.sharePopVC dismiss];
            };
            self.sharePopVC = [[zhPopupController alloc] initWithView:giftView size:giftView.bounds.size];
            self.sharePopVC.layoutType = zhPopupLayoutTypeBottom;
            [self.sharePopVC show];
        }
    }else{
        if (_orderData.brand_rebate && _orderData.brand_rebate.count) {
            GXRebateView *rebateView = [GXRebateView loadXibView];
            rebateView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 400.f);
            rebateView.brand_rebate = _orderData.brand_rebate;
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
