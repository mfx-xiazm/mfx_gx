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
    
    if (_orderDetail.username && _orderDetail.username.length) {
        [self.order_desc setTextWithLineSpace:5.f withString:[NSString stringWithFormat:@"订单编号：%@\n下单时间：%@\n发货商家：%@\n推广店员：%@（%@）",_orderDetail.order_no,_orderDetail.create_time,_orderDetail.provider_no,_orderDetail.username,_orderDetail.saleman_code] withFont:[UIFont systemFontOfSize:13]];
    }else{
        [self.order_desc setTextWithLineSpace:5.f withString:[NSString stringWithFormat:@"订单编号：%@\n下单时间：%@\n发货商家：%@\n",_orderDetail.order_no,_orderDetail.create_time,_orderDetail.provider_no] withFont:[UIFont systemFontOfSize:13]];
    }
}
-(void)setRefundDetail:(GXMyRefund *)refundDetail
{
    _refundDetail = refundDetail;
    
    self.order_freight_amount.text = [NSString stringWithFormat:@"￥%@",_refundDetail.order_freight_amount];
    self.order_coupon_amount.text = [NSString stringWithFormat:@"-￥%@",_refundDetail.total_reduce_amount];
    self.order_price_amount.text = [NSString stringWithFormat:@"￥%@",_refundDetail.total_pay_amount];
    self.pay_amount.text = [NSString stringWithFormat:@"￥%@",_refundDetail.pay_amount];
    
    if (_refundDetail.username && _refundDetail.username.length) {
        [self.order_desc setTextWithLineSpace:5.f withString:[NSString stringWithFormat:@"订单编号：%@\n下单时间：%@\n发货商家：%@\n推广店员：%@（%@）",_refundDetail.order_no,_refundDetail.create_time,_refundDetail.provider_no,_refundDetail.username,_refundDetail.saleman_code] withFont:[UIFont systemFontOfSize:13]];
    }else{
        [self.order_desc setTextWithLineSpace:5.f withString:[NSString stringWithFormat:@"订单编号：%@\n下单时间：%@\n发货商家：%@\n",_refundDetail.order_no,_refundDetail.create_time,_refundDetail.provider_no] withFont:[UIFont systemFontOfSize:13]];
    }
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
