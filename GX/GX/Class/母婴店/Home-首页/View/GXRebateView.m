//
//  GXRebateView.m
//  GX
//
//  Created by huaxin-01 on 2020/6/11.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXRebateView.h"
#import "GXGoodsDetail.h"
#import "GXCartData.h"
#import "GXConfirmOrder.h"
#import "GXMyOrder.h"
#import "GXMyRefund.h"

@interface GXRebateView ()
@property (weak, nonatomic) IBOutlet UILabel *rebateTxt;

@end

@implementation GXRebateView

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setRebate:(NSArray<GXGoodsRebate *> *)rebate
{
    _rebate = rebate;
    NSMutableString *rebateStr = [NSMutableString string];
    for (GXGoodsRebate *rebateObj in _rebate) {
        if (rebateStr.length) {
            [rebateStr appendFormat:@"，%@",[NSString stringWithFormat:@"满%@返%@%%",rebateObj.begin_price,rebateObj.percent]];
        }else{
            [rebateStr appendFormat:@"%@",[NSString stringWithFormat:@"满%@返%@%%",rebateObj.begin_price,rebateObj.percent]];
        }
    }

    if (rebateStr.length) {
        [self.rebateTxt setTextWithLineSpace:10 withString:rebateStr withFont:[UIFont systemFontOfSize:13]];
    }else{
        self.rebateTxt.text = @"无";
    }
}
-(void)setCart_rebate:(NSArray<GXCartGoodsRebate *> *)cart_rebate
{
    _cart_rebate = cart_rebate;
    NSMutableString *rebateStr = [NSMutableString string];
    for (GXCartGoodsRebate *rebateObj in _cart_rebate) {
        if (rebateStr.length) {
            [rebateStr appendFormat:@"，%@",[NSString stringWithFormat:@"满%@返%@%%",rebateObj.begin_price,rebateObj.percent]];
        }else{
            [rebateStr appendFormat:@"%@",[NSString stringWithFormat:@"满%@返%@%%",rebateObj.begin_price,rebateObj.percent]];
        }
    }

    if (rebateStr.length) {
        [self.rebateTxt setTextWithLineSpace:10 withString:rebateStr withFont:[UIFont systemFontOfSize:13]];
    }else{
        self.rebateTxt.text = @"无";
    }
}
-(void)setBrand_rebate:(NSArray<GXConfirmBrandRebate *> *)brand_rebate
{
    _brand_rebate = brand_rebate;
    NSMutableString *rebateStr = [NSMutableString string];
    for (GXConfirmBrandRebate *rebateObj in _brand_rebate) {
        if (rebateStr.length) {
            [rebateStr appendFormat:@"，%@",[NSString stringWithFormat:@"%@满%@返%@%%",rebateObj.rebate_goods,rebateObj.begin_price,rebateObj.rebate_percent]];
        }else{
            [rebateStr appendFormat:@"%@",[NSString stringWithFormat:@"%@满%@返%@%%",rebateObj.rebate_goods,rebateObj.begin_price,rebateObj.rebate_percent]];
        }
    }

    if (rebateStr.length) {
        [self.rebateTxt setTextWithLineSpace:10 withString:rebateStr withFont:[UIFont systemFontOfSize:13]];
    }else{
        self.rebateTxt.text = @"无";
    }
}
-(void)setOrder_rebate:(NSArray<GXMyOrderRebate *> *)order_rebate
{
    _order_rebate = order_rebate;
    NSMutableString *rebateStr = [NSMutableString string];
    for (GXMyOrderRebate *rebateObj in _order_rebate) {
        if (rebateStr.length) {
            [rebateStr appendFormat:@"，%@",[NSString stringWithFormat:@"%@满%@返%@%%",rebateObj.rebate_goods,rebateObj.begin_price,rebateObj.rebate_percent]];
        }else{
            [rebateStr appendFormat:@"%@",[NSString stringWithFormat:@"%@满%@返%@%%",rebateObj.rebate_goods,rebateObj.begin_price,rebateObj.rebate_percent]];
        }
    }

    if (rebateStr.length) {
        [self.rebateTxt setTextWithLineSpace:10 withString:rebateStr withFont:[UIFont systemFontOfSize:13]];
    }else{
        self.rebateTxt.text = @"无";
    }
}
-(void)setRefund_rebate:(NSArray<GXMyRefundRebate *> *)refund_rebate
{
    _refund_rebate = refund_rebate;
    NSMutableString *rebateStr = [NSMutableString string];
    for (GXMyRefundRebate *rebateObj in _refund_rebate) {
        if (rebateStr.length) {
            [rebateStr appendFormat:@"，%@",[NSString stringWithFormat:@"%@满%@返%@%%",rebateObj.rebate_goods,rebateObj.begin_price,rebateObj.rebate_percent]];
        }else{
            [rebateStr appendFormat:@"%@",[NSString stringWithFormat:@"%@满%@返%@%%",rebateObj.rebate_goods,rebateObj.begin_price,rebateObj.rebate_percent]];
        }
    }

    if (rebateStr.length) {
        [self.rebateTxt setTextWithLineSpace:10 withString:rebateStr withFont:[UIFont systemFontOfSize:13]];
    }else{
        self.rebateTxt.text = @"无";
    }
}
- (IBAction)closeClicked:(UIButton *)sender {
    if (self.closeClickedCall) {
        self.closeClickedCall();
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self bezierPathByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
}
@end
