//
//  GXMyOrderHeader.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMyOrderHeader.h"
#import "GXMyOrder.h"
#import "GXMyRefund.h"

@interface GXMyOrderHeader ()
@property (weak, nonatomic) IBOutlet UILabel *order_no;
@property (weak, nonatomic) IBOutlet UILabel *order_state;
@end
@implementation GXMyOrderHeader

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
