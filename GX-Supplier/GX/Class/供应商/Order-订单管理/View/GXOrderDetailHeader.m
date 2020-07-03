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
#import "GXGiftGoods.h"

@interface GXOrderDetailHeader ()
@property (weak, nonatomic) IBOutlet UILabel *order_status;
@property (weak, nonatomic) IBOutlet UILabel *order_desc;
@property (weak, nonatomic) IBOutlet UILabel *order_tip;
@property (weak, nonatomic) IBOutlet UILabel *logistics_name;
@property (weak, nonatomic) IBOutlet UILabel *logistics_no;
@property (weak, nonatomic) IBOutlet UILabel *receiver;
@property (weak, nonatomic) IBOutlet UILabel *receive_address;
@property (weak, nonatomic) IBOutlet UILabel *order_no;
@property (weak, nonatomic) IBOutlet UIButton *gift_order;
@end
@implementation GXOrderDetailHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.hxn_height = 275.f;
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
                self.order_desc.text = @"您的订单待审核";
                self.order_tip.text = @"   订单待审核，请耐心等待   ";
            }
        }else{
            self.order_desc.text = @"您的订单待发货";
            self.order_tip.text = @"   订单待发货，请在48小时内发货！！！   ";
        }
    }else if ([_orderDetail.status isEqualToString:@"待收货"]) {
        self.order_desc.text = @"您的订单已发货，请耐心等待";
        self.order_tip.hidden = YES;
        self.logistics_name.text = [NSString stringWithFormat:@"快递公司：%@",_orderDetail.logistics_com_name];
        if (_orderDetail.logistics_no && _orderDetail.logistics_no.length) {
            self.logistics_no.text = [NSString stringWithFormat:@"快递单号：%@",_orderDetail.logistics_no];
        }else if (_orderDetail.driver_phone && _orderDetail.driver_phone.length) {
            self.logistics_no.text = [NSString stringWithFormat:@"司机电话：%@",_orderDetail.driver_phone];
        }else{
            self.logistics_no.text = @"";
        }
    }else {
        if ([_orderDetail.status isEqualToString:@"待收货"]) {
            self.order_desc.text = @"您的订单已发货，请耐心等待";
            self.order_tip.hidden = YES;
        }else if ([_orderDetail.status isEqualToString:@"待评价"]) {
            self.order_desc.text = @"您的评价对其他买家有帮助哦";
            self.order_tip.hidden = YES;
        }else {
            self.order_desc.text = @"您的订单已完成，棒棒哒";
            self.order_tip.hidden = YES;
        }
        // 1快递；2快运；3物流
        if ([_orderDetail.send_freight_type isEqualToString:@"1"]) {
            self.logistics_name.text = [NSString stringWithFormat:@"快递公司：%@",_orderDetail.logistics_com_name];
            if (_orderDetail.logistics_no && _orderDetail.logistics_no.length) {
                self.logistics_no.text = [NSString stringWithFormat:@"快递单号：%@",_orderDetail.logistics_no];
            }else if (_orderDetail.driver_phone && _orderDetail.driver_phone.length) {
                self.logistics_no.text = [NSString stringWithFormat:@"司机电话：%@",_orderDetail.driver_phone];
            }else{
                self.logistics_no.text = @"";
            }
        }else if ([_orderDetail.send_freight_type isEqualToString:@"2"]) {
            self.logistics_name.text = [NSString stringWithFormat:@"快运公司：%@",_orderDetail.logistics_com_name];
            if (_orderDetail.logistics_no && _orderDetail.logistics_no.length) {
                self.logistics_no.text = [NSString stringWithFormat:@"快运单号：%@",_orderDetail.logistics_no];
            }else if (_orderDetail.driver_phone && _orderDetail.driver_phone.length) {
                self.logistics_no.text = [NSString stringWithFormat:@"司机电话：%@",_orderDetail.driver_phone];
            }else{
                self.logistics_no.text = @"";
            }
        }else {
            self.logistics_name.text = [NSString stringWithFormat:@"物流公司：%@",_orderDetail.logistics_com_name];
            if (_orderDetail.logistics_no && _orderDetail.logistics_no.length) {
                self.logistics_no.text = [NSString stringWithFormat:@"物流单号：%@",_orderDetail.logistics_no];
            }else if (_orderDetail.driver_phone && _orderDetail.driver_phone.length) {
                self.logistics_no.text = [NSString stringWithFormat:@"司机电话：%@",_orderDetail.driver_phone];
            }else{
                self.logistics_no.text = @"";
            }
        }
    }
    
    self.receiver.text = [NSString stringWithFormat:@"%@  %@",_orderDetail.receiver,_orderDetail.receiver_phone];
    self.receive_address.text = [NSString stringWithFormat:@"%@%@",_orderDetail.area_name,_orderDetail.address_detail];
    
    self.gift_order.hidden = (_orderDetail.gift_order_id && _orderDetail.gift_order_id.length)?NO:YES;
    self.order_no.text = [NSString stringWithFormat:@"%@",_orderDetail.provider_no];
}
-(void)setRefundDetail:(GXMyRefund *)refundDetail
{
    _refundDetail = refundDetail;
    /* 1等待供应商审核 2等待平台审核 3退款成功 4退款驳回 5供应商同意 6供应商不同意*/
    if ([_refundDetail.refund_status isEqualToString:@"1"]) {
        self.order_status.text = @"退款中，等待供应商审核";
        self.order_desc.hidden = YES;

    }else if ([_refundDetail.refund_status isEqualToString:@"2"]){
        self.order_status.text = @"退款中，等待平台审核";
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
    
    if (![_refundDetail.status isEqualToString:@"已取消"] && ![_refundDetail.status isEqualToString:@"待付款"] && ![_refundDetail.status isEqualToString:@"待发货"]) {
        self.order_tip.hidden = YES;
        // 1快递；2快运；3物流
        if ([_refundDetail.send_freight_type isEqualToString:@"1"]) {
            self.logistics_name.text = [NSString stringWithFormat:@"快递公司：%@",_refundDetail.logistics_com_name];
            if (_refundDetail.logistics_no && _refundDetail.logistics_no.length) {
                self.logistics_no.text = [NSString stringWithFormat:@"快递单号：%@",_refundDetail.logistics_no];
            }else if (_refundDetail.driver_phone && _refundDetail.driver_phone.length) {
                self.logistics_no.text = [NSString stringWithFormat:@"司机电话：%@",_refundDetail.driver_phone];
            }else{
                self.logistics_no.text = @"";
            }
        }else if ([_refundDetail.send_freight_type isEqualToString:@"2"]) {
            self.logistics_name.text = [NSString stringWithFormat:@"快运公司：%@",_refundDetail.logistics_com_name];
            if (_refundDetail.logistics_no && _refundDetail.logistics_no.length) {
                self.logistics_no.text = [NSString stringWithFormat:@"快运单号：%@",_refundDetail.logistics_no];
            }else if (_refundDetail.driver_phone && _refundDetail.driver_phone.length) {
                self.logistics_no.text = [NSString stringWithFormat:@"司机电话：%@",_refundDetail.driver_phone];
            }else{
                self.logistics_no.text = @"";
            }
        }else {
            self.logistics_name.text = [NSString stringWithFormat:@"物流公司：%@",_refundDetail.logistics_com_name];
            if (_refundDetail.logistics_no && _refundDetail.logistics_no.length) {
                self.logistics_no.text = [NSString stringWithFormat:@"物流单号：%@",_refundDetail.logistics_no];
            }else if (_refundDetail.driver_phone && _refundDetail.driver_phone.length) {
                self.logistics_no.text = [NSString stringWithFormat:@"司机电话：%@",_refundDetail.driver_phone];
            }else{
                self.logistics_no.text = @"";
            }
        }
    }else{
        self.order_tip.hidden = NO;
        self.order_tip.text = [NSString stringWithFormat:@"  %@  ",self.order_status.text];
    }
    
    self.receiver.text = [NSString stringWithFormat:@"%@  %@",_refundDetail.receiver,_refundDetail.receiver_phone];
    self.receive_address.text = [NSString stringWithFormat:@"%@%@",_refundDetail.area_name,_refundDetail.address_detail];
    
    self.gift_order.hidden = (_refundDetail.gift_order_id &&_refundDetail.gift_order_id.length)?NO:YES;
    self.order_no.text = [NSString stringWithFormat:@"%@",_refundDetail.provider_no];
}
- (IBAction)lookLogisClicked:(UIButton *)sender {
    if (self.refundDetail) {
        if ([_refundDetail.status isEqualToString:@"已取消"] || [_refundDetail.status isEqualToString:@"待付款"] || [_refundDetail.status isEqualToString:@"待发货"]) {
            return;
        }
        if (_refundDetail.logistics_no && _refundDetail.logistics_no.length) {
            if (self.lookLogisCall) {
                self.lookLogisCall();
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请联系快递公司"];
        }
    }else if (self.orderDetail){
        if ([_orderDetail.status isEqualToString:@"已取消"] || [_orderDetail.status isEqualToString:@"待付款"] || [_orderDetail.status isEqualToString:@"待发货"]) {
            return;
        }
        if (_orderDetail.logistics_no && _orderDetail.logistics_no.length) {
            if (self.lookLogisCall) {
                self.lookLogisCall();
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请联系快递公司"];
        }
    }else{
        if ([_giftGoods.gift_order_status isEqualToString:@"待发货"]) {
            return;
        }
        if (_giftGoods.logistics_no && _giftGoods.logistics_no.length) {
            if (self.lookLogisCall) {
                self.lookLogisCall();
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请联系快递公司"];
        }
    }
}
-(void)setGiftGoods:(GXGiftGoods *)giftGoods
{
    _giftGoods = giftGoods;
    
    self.order_status.text = _giftGoods.gift_order_status;
    if ([_giftGoods.gift_order_status isEqualToString:@"待发货"]) {
        self.order_tip.hidden = NO;
        self.order_desc.text = @"您的赠品订单待发货";
        self.order_tip.text = @"   赠品订单待发货，请耐心等待   ";
    }else {
        if ([_giftGoods.gift_order_status isEqualToString:@"待收货"]) {
            self.order_desc.text = @"您的赠品订单已发货，请耐心等待";
            self.order_tip.hidden = YES;
        }else{
            self.order_desc.text = @"您的赠品订单已完成，棒棒哒";
            self.order_tip.hidden = YES;
        }
       
        // 1快递；2快运；3物流
        if ([_giftGoods.send_freight_type isEqualToString:@"1"]) {
            self.logistics_name.text = [NSString stringWithFormat:@"快递公司：%@",_giftGoods.logistics_com_name];
            if (_giftGoods.logistics_no && _giftGoods.logistics_no.length) {
                self.logistics_no.text = [NSString stringWithFormat:@"快递单号：%@",_giftGoods.logistics_no];
            }else if (_giftGoods.driver_phone && _giftGoods.driver_phone.length) {
                self.logistics_no.text = [NSString stringWithFormat:@"司机电话：%@",_giftGoods.driver_phone];
            }else{
                self.logistics_no.text = @"";
            }
        }else if ([_giftGoods.send_freight_type isEqualToString:@"2"]) {
            self.logistics_name.text = [NSString stringWithFormat:@"快运公司：%@",_giftGoods.logistics_com_name];
            if (_giftGoods.logistics_no && _giftGoods.logistics_no.length) {
                self.logistics_no.text = [NSString stringWithFormat:@"快运单号：%@",_giftGoods.logistics_no];
            }else if (_giftGoods.driver_phone && _giftGoods.driver_phone.length) {
                self.logistics_no.text = [NSString stringWithFormat:@"司机电话：%@",_giftGoods.driver_phone];
            }else{
                self.logistics_no.text = @"";
            }
        }else {
            self.logistics_name.text = [NSString stringWithFormat:@"物流公司：%@",_giftGoods.logistics_com_name];
            if (_giftGoods.logistics_no && _giftGoods.logistics_no.length) {
                self.logistics_no.text = [NSString stringWithFormat:@"物流单号：%@",_giftGoods.logistics_no];
            }else if (_giftGoods.driver_phone && _giftGoods.driver_phone.length) {
                self.logistics_no.text = [NSString stringWithFormat:@"司机电话：%@",_giftGoods.driver_phone];
            }else{
                self.logistics_no.text = @"";
            }
        }
    }
    
    self.receiver.text = [NSString stringWithFormat:@"%@  %@",_giftGoods.receiver,_giftGoods.receiver_phone];
    self.receive_address.text = [NSString stringWithFormat:@"%@%@",_giftGoods.area_name,_giftGoods.address_detail];
    
    self.gift_order.hidden = YES;
    self.order_no.text = [NSString stringWithFormat:@"%@",_giftGoods.provider_no];
}
- (IBAction)lookGiftOrder:(UIButton *)sender {
    if (self.lookGiftOrderCall) {
        self.lookGiftOrderCall();
    }
}

@end
