//
//  GXRenewMyOrderFooter.m
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXRenewMyOrderFooter.h"
#import "GXMyOrder.h"
#import "GXMyRefund.h"

@interface GXRenewMyOrderFooter ()
@property (weak, nonatomic) IBOutlet UILabel *total_price;
@property (weak, nonatomic) IBOutlet UIButton *firstHandleBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondHandleBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdHandleBtn;
@property (weak, nonatomic) IBOutlet UILabel *tuiLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuiAmount;

@end
@implementation GXRenewMyOrderFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)setOrder:(GXMyOrder *)order
{
    _order = order;
    self.tuiLabel.hidden = YES;
    self.tuiAmount.hidden = YES;
    /** 待付款 - 取消订单、立即付款  待发货 - 申请退款[线下审核未通过 - 无]  待收货 - 申请退款、查看物流、确认收货  待评价 - 评价  已完成/退款列表 - 无*/
    self.total_price.text = [NSString stringWithFormat:@"￥%@",_order.pay_amount];
    if ([_order.status isEqualToString:@"待付款"]) {
        self.firstHandleBtn.hidden = YES;

        self.secondHandleBtn.hidden = NO;
        [self.secondHandleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        self.secondHandleBtn.backgroundColor = [UIColor whiteColor];
        self.secondHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
        [self.secondHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.thirdHandleBtn.hidden = NO;
        [self.thirdHandleBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        self.thirdHandleBtn.backgroundColor = HXControlBg;
        self.thirdHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [self.thirdHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else if ([_order.status isEqualToString:@"待发货"]) {
        if ([_order.pay_type isEqualToString:@"3"]) {// 线下付款
            if ([_order.approve_status isEqualToString:@"2"]) {//订单审核通过
                self.firstHandleBtn.hidden = YES;
                self.secondHandleBtn.hidden = YES;

                self.thirdHandleBtn.hidden = NO;
                [self.thirdHandleBtn setTitle:@"售后退款" forState:UIControlStateNormal];
                self.thirdHandleBtn.backgroundColor = [UIColor whiteColor];
                self.thirdHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                [self.thirdHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                self.firstHandleBtn.hidden = YES;
                self.secondHandleBtn.hidden = YES;

                self.thirdHandleBtn.hidden = NO;
                [self.thirdHandleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                self.thirdHandleBtn.backgroundColor = [UIColor whiteColor];
                self.thirdHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                [self.thirdHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }else{
            self.firstHandleBtn.hidden = YES;
            self.secondHandleBtn.hidden = YES;

            self.thirdHandleBtn.hidden = NO;
            [self.thirdHandleBtn setTitle:@"售后退款" forState:UIControlStateNormal];
            self.thirdHandleBtn.backgroundColor = [UIColor whiteColor];
            self.thirdHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
            [self.thirdHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }else if ([_order.status isEqualToString:@"待收货"]) {
        self.firstHandleBtn.hidden = NO;
        [self.firstHandleBtn setTitle:@"售后退款" forState:UIControlStateNormal];
        self.firstHandleBtn.backgroundColor = [UIColor whiteColor];
        self.firstHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
        [self.firstHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.secondHandleBtn.hidden = NO;
        [self.secondHandleBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        self.secondHandleBtn.backgroundColor = [UIColor whiteColor];
        self.secondHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
        [self.secondHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.thirdHandleBtn.hidden = NO;
        [self.thirdHandleBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        self.thirdHandleBtn.backgroundColor = HXControlBg;
        self.thirdHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [self.thirdHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if ([_order.status isEqualToString:@"待评价"]) {
        self.firstHandleBtn.hidden = YES;
        
        self.thirdHandleBtn.hidden = NO;
        [self.thirdHandleBtn setTitle:@"评价" forState:UIControlStateNormal];
        self.thirdHandleBtn.backgroundColor = HXControlBg;
        self.thirdHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [self.thirdHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        if ([_order.isRefund isEqualToString:@"1"]) {//可以售后退款
            self.secondHandleBtn.hidden = NO;
            [self.secondHandleBtn setTitle:@"售后退款" forState:UIControlStateNormal];
            self.secondHandleBtn.backgroundColor = [UIColor whiteColor];
            self.secondHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
            [self.secondHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{// 不可以售后退款
            self.secondHandleBtn.hidden = YES;
        }
    }else{
        self.firstHandleBtn.hidden = YES;
        
        self.thirdHandleBtn.hidden = NO;
        [self.thirdHandleBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        self.thirdHandleBtn.backgroundColor = [UIColor whiteColor];
        self.thirdHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
        [self.thirdHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        if ([_order.isRefund isEqualToString:@"1"]) {//可以售后退款
            self.secondHandleBtn.hidden = NO;
            [self.secondHandleBtn setTitle:@"售后退款" forState:UIControlStateNormal];
            self.secondHandleBtn.backgroundColor = [UIColor whiteColor];
            self.secondHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
            [self.secondHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{// 不可以售后退款
            self.secondHandleBtn.hidden = YES;
        }
    }
}
-(void)setRefund:(GXMyRefund *)refund
{
    _refund = refund;
    self.tuiLabel.hidden = NO;
    self.tuiAmount.hidden = NO;
    
    self.tuiAmount.text = [NSString stringWithFormat:@"￥%@",(_refund.return_amount && _refund.return_amount.length)?_refund.return_amount:_refund.pay_amount];
    
    self.total_price.text = [NSString stringWithFormat:@"￥%@",_refund.pay_amount];
}
- (IBAction)orderHandleClicked:(UIButton *)sender {
    if (self.orderHandleCall) {
        self.orderHandleCall(sender.tag);
    }
}
@end
