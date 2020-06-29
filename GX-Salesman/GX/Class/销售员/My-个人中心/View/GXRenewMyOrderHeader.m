//
//  GXRenewMyOrderHeader.m
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXRenewMyOrderHeader.h"
#import "GXMyOrder.h"
#import "GXMyRefund.h"
#import "GXSalerOrder.h"

@interface GXRenewMyOrderHeader ()
@property (weak, nonatomic) IBOutlet UILabel *order_no;
@property (weak, nonatomic) IBOutlet UILabel *order_state;
@property (weak, nonatomic) IBOutlet UIButton *out_line_status;

@end

@implementation GXRenewMyOrderHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setOrder:(GXMyOrder *)order
{
    _order = order;
    if (_order.isDetailOrder) {
        self.order_state.text = @"";
        self.order_no.text = [NSString stringWithFormat:@"%@",_order.provider_no];
    }else{
        self.order_state.text = _order.status;
        self.order_no.text = [NSString stringWithFormat:@"%@",_order.order_no];
    }
}
-(void)setRefund:(GXMyRefund *)refund
{
    _refund = refund;
    
    /** 1等待供应商审核；2等待平台审核；3退款成功；4退款驳回 5供应商同意 6供应商不同意 */
    if (_refund.isRefundDetail) {
        self.order_state.text = @"";
        self.order_no.text = [NSString stringWithFormat:@"%@",_refund.provider_no];
    }else{
        self.order_no.text = [NSString stringWithFormat:@"%@",_refund.order_no];
        if ([_refund.refund_status isEqualToString:@"1"]) {
            self.order_state.text = @"退款中，等待供应商审核";
        }else if ([_refund.refund_status isEqualToString:@"2"]){
            self.order_state.text = @"退款中，等待平台审核";
        }else if ([_refund.refund_status isEqualToString:@"3"]){
            self.order_state.text = @"退款成功";
        }else if ([_refund.refund_status isEqualToString:@"4"]){
            self.order_state.text = @"退款驳回";
        }else if ([_refund.refund_status isEqualToString:@"5"]){
            self.order_state.text = @"供应商同意";
        }else{
            self.order_state.text = @"供应商不同意";
        }
    }
}
-(void)setSalerOrder:(GXSalerOrder *)salerOrder
{
    _salerOrder = salerOrder;
    if (_salerOrder.refund_id && _salerOrder.refund_id.length) {
        if ([_salerOrder.refund_status isEqualToString:@"1"]) {
            self.order_state.text = @"退款中，等待供应商审核";
        }else if ([_salerOrder.refund_status isEqualToString:@"2"]){
            self.order_state.text = @"退款中，等待平台审核";
        }else if ([_salerOrder.refund_status isEqualToString:@"3"]){
            self.order_state.text = @"退款成功";
        }else if ([_salerOrder.refund_status isEqualToString:@"4"]){
            self.order_state.text = @"退款驳回";
        }else if ([_salerOrder.refund_status isEqualToString:@"5"]){
            self.order_state.text = @"供应商同意";
        }else{
            self.order_state.text = @"供应商不同意";
        }
    }else{
        self.order_state.text = _salerOrder.status;
    }
    self.order_no.text = [NSString stringWithFormat:@"%@",_salerOrder.order_no];
    
    if ([_salerOrder.status isEqualToString:@"待发货"]) {
        if ([_salerOrder.order_status isEqualToString:@"1"]) {
            self.out_line_status.hidden = NO;
            [self.out_line_status setImage:HXGetImage(@"超时") forState:UIControlStateNormal];
            [self.out_line_status setTitle:@"  超时未发货" forState:UIControlStateNormal];
        }else{
            self.out_line_status.hidden = YES;
        }
    }else if ([_salerOrder.status isEqualToString:@"待收货"]) {
        if ([_salerOrder.order_status isEqualToString:@"2"]) {
            self.out_line_status.hidden = NO;
            [self.out_line_status setImage:HXGetImage(@"超时") forState:UIControlStateNormal];
            [self.out_line_status setTitle:@"  超时已发货" forState:UIControlStateNormal];
        }else{
            self.out_line_status.hidden = YES;
        }
    }else{
        self.out_line_status.hidden = YES;
    }
}
@end
