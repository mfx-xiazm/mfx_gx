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
#import "GXExpressShowView.h"
#import <zhPopupController.h>

@interface GXOrderDetailFooter ()
@property(nonatomic,weak) IBOutlet UILabel *order_freight_amount;
@property(nonatomic,weak) IBOutlet UILabel *order_coupon_amount;
@property(nonatomic,weak) IBOutlet UILabel *pay_amount;
@property (weak, nonatomic) IBOutlet UILabel *order_desc;
@property (weak, nonatomic) IBOutlet UILabel *goods_num;
@property (weak, nonatomic) IBOutlet UIButton *locitic_copy;
@property (nonatomic, strong) zhPopupController *alertPopVC;
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
    self.pay_amount.text = [NSString stringWithFormat:@"￥%@",_orderDetail.pay_amount];
    NSInteger goods_num = 0;
    for (GXMyOrderProvider *provider in _orderDetail.provider) {
        goods_num += provider.goods.count;
    }
    self.goods_num.text = [NSString stringWithFormat:@"共%zd件商品",goods_num];
    
    NSMutableString *infoStr = [NSMutableString string];
    [infoStr appendFormat:@"%@",[NSString stringWithFormat:@"订单编号：%@\n下单时间：%@",_orderDetail.order_no,_orderDetail.create_time]];

    // 1快递；2快运；3物流
    if (_orderDetail.logistics_com_name && _orderDetail.logistics_com_name.length) {
        self.locitic_copy.hidden = NO;
        if (_orderDetail.logistics_nos.count > 1) {
            [self.locitic_copy setTitle:@"  查看全部  " forState:UIControlStateNormal];
        }else{
            [self.locitic_copy setTitle:@"  复制  " forState:UIControlStateNormal];
        }
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
    }else{
        self.locitic_copy.hidden = YES;
    }
    [infoStr appendFormat:@"%@",[NSString stringWithFormat:@"\n发货商家：%@",_orderDetail.provider_no]];
    
    [self.order_desc setTextWithLineSpace:10.f withString:infoStr withFont:[UIFont systemFontOfSize:13]];
}
-(void)setRefundDetail:(GXMyRefund *)refundDetail
{
    _refundDetail = refundDetail;
    
    self.order_freight_amount.text = [NSString stringWithFormat:@"￥%@",_refundDetail.order_freight_amount];
    self.order_coupon_amount.text = [NSString stringWithFormat:@"-￥%@",_refundDetail.total_reduce_amount];
    self.pay_amount.text = [NSString stringWithFormat:@"￥%@",_refundDetail.pay_amount];
    
    NSMutableString *infoStr = [NSMutableString string];
    [infoStr appendFormat:@"%@",[NSString stringWithFormat:@"订单编号：%@\n下单时间：%@",_refundDetail.order_no,_refundDetail.create_time]];

    // 1快递；2快运；3物流
    if (_refundDetail.logistics_com_name && _refundDetail.logistics_com_name.length) {
        self.locitic_copy.hidden = NO;
        if (_refundDetail.logistics_nos.count > 1) {
            [self.locitic_copy setTitle:@"  查看全部  " forState:UIControlStateNormal];
        }else{
            [self.locitic_copy setTitle:@"  复制  " forState:UIControlStateNormal];
        }
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
    }else{
        self.locitic_copy.hidden = YES;
    }
    [infoStr appendFormat:@"%@",[NSString stringWithFormat:@"\n发货商家：%@",_refundDetail.provider_no]];
   
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
- (IBAction)logisticsNoCopyClicked:(UIButton *)sender {
    if (self.refundDetail) {
        if (_refundDetail.logistics_nos.count > 1) {
            GXExpressShowView *show = [GXExpressShowView loadXibView];
            show.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 300.f);
            show.logistics_nos = _refundDetail.logistics_nos;
            hx_weakify(self);
            show.expressShowCloseClicked = ^{
                hx_strongify(weakSelf);
                [strongSelf.alertPopVC dismiss];
            };
            self.alertPopVC = [[zhPopupController alloc] initWithView:show size:show.bounds.size];
            self.alertPopVC.layoutType = zhPopupLayoutTypeBottom;
            [self.alertPopVC show];
        }else{
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = _refundDetail.logistics_no;
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"复制成功"];
        }
    }else{
        if (_orderDetail.logistics_nos.count > 1) {
            GXExpressShowView *show = [GXExpressShowView loadXibView];
            show.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 300.f);
            show.logistics_nos = _orderDetail.logistics_nos;
            hx_weakify(self);
            show.expressShowCloseClicked = ^{
                hx_strongify(weakSelf);
                [strongSelf.alertPopVC dismiss];
            };
            self.alertPopVC = [[zhPopupController alloc] initWithView:show size:show.bounds.size];
            self.alertPopVC.layoutType = zhPopupLayoutTypeBottom;
            [self.alertPopVC show];
        }else{
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = _orderDetail.logistics_no;
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"复制成功"];
        }
    }
}

@end
