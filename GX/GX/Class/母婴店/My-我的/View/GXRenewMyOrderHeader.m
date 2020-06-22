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
        self.out_line_status.hidden = YES;
    }else{
        self.order_state.text = _order.status;
        self.order_no.text = [NSString stringWithFormat:@"%@",_order.order_no];
        /**线下支付审核状态：1待上传打款凭证；2审核通过；3审核驳回。4上传打款凭证审核中；线上支付不需要审核逻辑*/
        if ([_order.approve_status isEqualToString:@"1"]) {
            self.out_line_status.hidden = NO;
            [self.out_line_status setTitle:@"  未打款" forState:UIControlStateNormal];
        }else if ([_order.approve_status isEqualToString:@"4"]) {
            self.out_line_status.hidden = NO;
            [self.out_line_status setTitle:@"  审核中" forState:UIControlStateNormal];
        }else{
            self.out_line_status.hidden = YES;
        }
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
            self.order_state.text = @"等待供应商审核";
        }else if ([_refund.refund_status isEqualToString:@"2"]){
            self.order_state.text = @"等待平台审核";
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

@end
