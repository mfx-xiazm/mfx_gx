//
//  GXOrderDetailFooter.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXOrderDetailFooter.h"
#import "GXMyOrder.h"
#import "GXMyRefund.h"

@interface GXOrderDetailFooter ()
@property(nonatomic,weak) IBOutlet UILabel *order_freight_amount;
@property(nonatomic,weak) IBOutlet UILabel *order_coupon_amount;
@property(nonatomic,weak) IBOutlet UILabel *order_price_amount;
@property(nonatomic,weak) IBOutlet UILabel *pay_amount;
@property (weak, nonatomic) IBOutlet UILabel *order_desc;
@property (weak, nonatomic) IBOutlet UILabel *goods_num;
@end
@implementation GXOrderDetailFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)setOrderDetail:(GXMyOrder *)orderDetail
{
    _orderDetail = orderDetail;
   
    self.order_freight_amount.text = [NSString stringWithFormat:@"￥%@",_orderDetail.order_freight_amount];
    self.order_coupon_amount.text = [NSString stringWithFormat:@"-￥%@",_orderDetail.total_reduce_amount];
    self.order_price_amount.text = [NSString stringWithFormat:@"￥%@",_orderDetail.total_pay_amount];
    self.pay_amount.text = [NSString stringWithFormat:@"￥%@",_orderDetail.pay_amount];
    self.goods_num.text = [NSString stringWithFormat:@"共%zd件商品",_orderDetail.goods.count];
    
    NSMutableString *infoStr = [NSMutableString string];
    [infoStr appendFormat:@"%@",[NSString stringWithFormat:@"订单编号：%@\n下单时间：%@",_orderDetail.order_no,_orderDetail.create_time]];

    // 1快递；2快运；3物流
    if (_orderDetail.logistics_com_name && _orderDetail.logistics_com_name.length) {
        if ([_orderDetail.send_freight_type isEqualToString:@"1"]) {
            [infoStr appendFormat:@"\n快递公司：%@",_orderDetail.logistics_com_name];
            if (_orderDetail.logistics_no && _orderDetail.logistics_no.length) {
                [infoStr appendFormat:@"\n快递单号：%@",_orderDetail.logistics_no];
            }else if (_orderDetail.driver_phone && _orderDetail.driver_phone.length) {
                [infoStr appendFormat:@"\n司机电话：%@",_orderDetail.driver_phone];
            }else{
                
            }
        }else if ([_orderDetail.send_freight_type isEqualToString:@"2"]) {
            [infoStr appendFormat:@"\n快运公司：%@",_orderDetail.logistics_com_name];
            if (_orderDetail.logistics_no && _orderDetail.logistics_no.length) {
                [infoStr appendFormat:@"\n快运单号：%@",_orderDetail.logistics_no];
            }else if (_orderDetail.driver_phone && _orderDetail.driver_phone.length) {
                [infoStr appendFormat:@"\n司机电话：%@",_orderDetail.driver_phone];
            }else{
                
            }
        }else {
            [infoStr appendFormat:@"\n物流公司：%@",_orderDetail.logistics_com_name];
            if (_orderDetail.logistics_no && _orderDetail.logistics_no.length) {
                [infoStr appendFormat:@"\n物流单号：%@",_orderDetail.logistics_no];
            }else if (_orderDetail.driver_phone && _orderDetail.driver_phone.length) {
                [infoStr appendFormat:@"\n司机电话：%@",_orderDetail.driver_phone];
            }else{
                
            }
        }
    }
    [infoStr appendFormat:@"%@",[NSString stringWithFormat:@"\n发货商家：%@",_orderDetail.provider_no]];
    if (_orderDetail.username && _orderDetail.username.length) {
        [infoStr appendFormat:@"\n推广店员：%@（%@）",_orderDetail.username,_orderDetail.saleman_code];
    }
    [self.order_desc setTextWithLineSpace:10.f withString:infoStr withFont:[UIFont systemFontOfSize:13]];
}
-(void)setRefundDetail:(GXMyRefund *)refundDetail
{
    _refundDetail = refundDetail;
    
    self.order_freight_amount.text = [NSString stringWithFormat:@"￥%@",_refundDetail.order_freight_amount];
    self.order_coupon_amount.text = [NSString stringWithFormat:@"-￥%@",_refundDetail.total_reduce_amount];
    self.order_price_amount.text = [NSString stringWithFormat:@"￥%@",_refundDetail.total_pay_amount];
    self.pay_amount.text = [NSString stringWithFormat:@"￥%@",_refundDetail.pay_amount];
    
    NSMutableString *infoStr = [NSMutableString string];
    [infoStr appendFormat:@"%@",[NSString stringWithFormat:@"订单编号：%@\n下单时间：%@\n发货商家：%@",_refundDetail.order_no,_refundDetail.create_time,_refundDetail.provider_no]];

    // 1快递；2快运；3物流
    if (_refundDetail.logistics_com_name && _refundDetail.logistics_com_name.length) {
        if ([_refundDetail.send_freight_type isEqualToString:@"1"]) {
            [infoStr appendFormat:@"\n快递公司：%@",_refundDetail.logistics_com_name];
            if (_refundDetail.logistics_no && _refundDetail.logistics_no.length) {
                [infoStr appendFormat:@"\n快递单号：%@",_refundDetail.logistics_no];
            }else if (_refundDetail.driver_phone && _refundDetail.driver_phone.length) {
                [infoStr appendFormat:@"\n司机电话：%@",_refundDetail.driver_phone];
            }else{
                
            }
        }else if ([_refundDetail.send_freight_type isEqualToString:@"2"]) {
            [infoStr appendFormat:@"\n快运公司：%@",_refundDetail.logistics_com_name];
            if (_refundDetail.logistics_no && _refundDetail.logistics_no.length) {
                [infoStr appendFormat:@"\n快运单号：%@",_refundDetail.logistics_no];
            }else if (_refundDetail.driver_phone && _refundDetail.driver_phone.length) {
                [infoStr appendFormat:@"\n司机电话：%@",_refundDetail.driver_phone];
            }else{
                
            }
        }else {
            [infoStr appendFormat:@"\n物流公司：%@",_refundDetail.logistics_com_name];
            if (_refundDetail.logistics_no && _refundDetail.logistics_no.length) {
                [infoStr appendFormat:@"\n物流单号：%@",_refundDetail.logistics_no];
            }else if (_refundDetail.driver_phone && _refundDetail.driver_phone.length) {
                [infoStr appendFormat:@"\n司机电话：%@",_refundDetail.driver_phone];
            }else{
                
            }
        }
    }
    [infoStr appendFormat:@"%@",[NSString stringWithFormat:@"\n发货商家：%@",_refundDetail.provider_no]];
    if (_refundDetail.username && _refundDetail.username.length) {
        [infoStr appendFormat:@"\n推广店员：%@（%@）",_refundDetail.username,_refundDetail.saleman_code];
    }
    [self.order_desc setTextWithLineSpace:10.f withString:infoStr withFont:[UIFont systemFontOfSize:13]];
}
- (IBAction)orderNoCopy:(id)sender {
    if (self.refundDetail) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _refundDetail.order_no;
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"复制成功"];
    }else{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _orderDetail.order_no;
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"复制成功"];
    }
}
@end
