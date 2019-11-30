//
//  GXOrderDetailHeader.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXOrderDetailHeader.h"
#import "GXMyOrder.h"
#import "GXMyRefund.h"

@interface GXOrderDetailHeader ()
@property (weak, nonatomic) IBOutlet UILabel *order_status;
@property (weak, nonatomic) IBOutlet UILabel *order_desc;
@property (weak, nonatomic) IBOutlet UILabel *order_tip;
@property (weak, nonatomic) IBOutlet UILabel *logistics_name;
@property (weak, nonatomic) IBOutlet UILabel *logistics_no;
@property (weak, nonatomic) IBOutlet UILabel *receiver;
@property (weak, nonatomic) IBOutlet UILabel *receive_address;
@end
@implementation GXOrderDetailHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setOrderDetail:(GXMyOrder *)orderDetail
{
    _orderDetail = orderDetail;
    self.order_status.text = _orderDetail.status;
    if ([_orderDetail.status isEqualToString:@"已取消"]) {
        self.order_desc.text = @"您的订单已取消";
        self.order_tip.hidden = NO;
        self.order_tip.text = @"   订单已取消   ";
    }else if ([_orderDetail.status isEqualToString:@"待付款"]) {
        self.order_desc.text = @"您的订单待付款";
        self.order_tip.hidden = NO;
        self.order_tip.text = @"   订单待付款，请尽快付款   ";
    }else if ([_orderDetail.status isEqualToString:@"待发货"]) {
        self.order_tip.hidden = NO;
        if ([self.orderDetail.pay_type isEqualToString:@"3"]) {// 线下付款
            if ([self.orderDetail.approve_status isEqualToString:@"3"]) {//订单审核通过
                self.order_desc.text = @"订单审核被拒";
                self.order_tip.text = [NSString stringWithFormat:@"   原因：%@   ",self.orderDetail.reject_reason];
            }else{
                self.order_desc.text = @"您的订单待发货";
                self.order_tip.text = @"   订单待发货，请耐心等待   ";
            }
        }else{
            self.order_desc.text = @"您的订单待发货";
            self.order_tip.text = @"   订单待发货，请耐心等待   ";
        }
    }else if ([_orderDetail.status isEqualToString:@"待收货"]) {
        self.order_desc.text = @"您的订单已发货，请耐心等待";
        self.order_tip.hidden = YES;
        self.logistics_name.text = [NSString stringWithFormat:@"物流公司：%@",_orderDetail.logistics_com_name];
        self.logistics_no.text = [NSString stringWithFormat:@"物流单号：%@",_orderDetail.logistics_no];
    }else if ([_orderDetail.status isEqualToString:@"待评价"]) {
        self.order_desc.text = @"您的评价对其他买家有帮助哦";
        self.order_tip.hidden = YES;
        self.logistics_name.text = [NSString stringWithFormat:@"物流公司：%@",_orderDetail.logistics_com_name];
        self.logistics_no.text = [NSString stringWithFormat:@"物流单号：%@",_orderDetail.logistics_no];
    }else{
        self.order_desc.text = @"您的订单已完成，棒棒哒";
        self.order_tip.hidden = YES;
        self.logistics_name.text = [NSString stringWithFormat:@"物流公司：%@",_orderDetail.logistics_com_name];
        self.logistics_no.text = [NSString stringWithFormat:@"物流单号：%@",_orderDetail.logistics_no];
    }
    
    self.receiver.text = [NSString stringWithFormat:@"%@  %@",_orderDetail.receiver,_orderDetail.receiver_phone];
    self.receive_address.text = [NSString stringWithFormat:@"%@%@",_orderDetail.area_name,_orderDetail.address_detail];
}
-(void)setRefundDetail:(GXMyRefund *)refundDetail
{
    _refundDetail = refundDetail;
    /* 1等待供应商审核 2等待平台审核 3退款成功 4退款驳回 5供应商同意 6供应商不同意*/
    if ([_refundDetail.refund_status isEqualToString:@"1"]) {
        self.order_status.text = @"等待供应商审核";
        self.order_desc.hidden = YES;

    }else if ([_refundDetail.refund_status isEqualToString:@"2"]){
        self.order_status.text = @"等待平台审核";
        self.order_desc.hidden = YES;

    }else if ([_refundDetail.refund_status isEqualToString:@"3"]){
        self.order_status.text = @"退款成功";
        self.order_desc.hidden = YES;

    }else if ([_refundDetail.refund_status isEqualToString:@"4"]){
        self.order_status.text = @"退款驳回";
        self.order_desc.hidden = YES;
        
    }else if ([_refundDetail.refund_status isEqualToString:@"5"]){
        self.order_status.text = @"供应商同意";
        self.order_desc.hidden = YES;

    }else{
        self.order_status.text = @"供应商不同意";
        self.order_desc.hidden = YES;
    }
    
    if (_refundDetail.logistics_no && _refundDetail.logistics_no.length) {
        self.order_tip.hidden = YES;
        self.logistics_name.text = [NSString stringWithFormat:@"物流公司：%@",_refundDetail.logistics_com_name];
        self.logistics_no.text = [NSString stringWithFormat:@"物流单号：%@",_refundDetail.logistics_no];
    }else{
        self.order_tip.hidden = NO;
        self.order_tip.text = [NSString stringWithFormat:@"  %@  ",self.order_status.text];
    }
    
    self.receiver.text = [NSString stringWithFormat:@"%@  %@",_refundDetail.receiver,_refundDetail.receiver_phone];
    self.receive_address.text = [NSString stringWithFormat:@"%@%@",_refundDetail.area_name,_refundDetail.address_detail];
}
- (IBAction)lookLogisClicked:(UIButton *)sender {
    if (self.refundDetail) {
        if (_refundDetail.logistics_no && _refundDetail.logistics_no.length) {
            if (self.lookLogisCall) {
                self.lookLogisCall();
            }
        }
    }else{
        if ([_orderDetail.status isEqualToString:@"已取消"] || [_orderDetail.status isEqualToString:@"待付款"] || [_orderDetail.status isEqualToString:@"待发货"]) {
            return;
        }
        if (self.lookLogisCall) {
            self.lookLogisCall();
        }
    }
}
@end
