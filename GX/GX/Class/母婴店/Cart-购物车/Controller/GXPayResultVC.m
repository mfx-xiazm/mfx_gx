//
//  GXPayResultVC.m
//  GX
//
//  Created by 夏增明 on 2019/11/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXPayResultVC.h"
#import "GXPayTypeVC.h"
#import "GXUpOrderVC.h"
#import "GXOrderDetailVC.h"
#import "GXOrderPay.h"

@interface GXPayResultVC ()
@property (weak, nonatomic) IBOutlet UILabel *payType;
@property (weak, nonatomic) IBOutlet UILabel *payAmount;
@property (weak, nonatomic) IBOutlet UILabel *account_name;
@property (weak, nonatomic) IBOutlet UILabel *bank_name;
@property (weak, nonatomic) IBOutlet UILabel *bank_no;
@property (weak, nonatomic) IBOutlet UILabel *tipDesc;
@property (weak, nonatomic) IBOutlet UIView *offLineView;
/** vc控制器 */
@property (nonatomic,strong) NSMutableArray *controllers;
@end

@implementation GXPayResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"支付结果"];

    hx_weakify(self);
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[GXUpOrderVC class]] || [obj isKindOfClass:[GXPayTypeVC class]]) {
            hx_strongify(weakSelf);
            [strongSelf.controllers removeObjectAtIndex:idx];
        }
    }];
    [self.navigationController setViewControllers:self.controllers];
    
    if ([self.pay_type isEqualToString:@"1"]) {
        [self.payType setColorAttributedText:[NSString stringWithFormat:@"支付方式：支付宝支付"] andChangeStr:@"支付宝支付" andColor:HXControlBg];
        self.offLineView.hidden = YES;
    }else if ([self.pay_type isEqualToString:@"2"]) {
        [self.payType setColorAttributedText:[NSString stringWithFormat:@"支付方式：微信支付"] andChangeStr:@"微信支付" andColor:HXControlBg];
        self.offLineView.hidden = YES;
    }else if ([self.pay_type isEqualToString:@"3"]) {
        [self.payType setColorAttributedText:[NSString stringWithFormat:@"支付方式：网银支付"] andChangeStr:@"网银支付" andColor:HXControlBg];
        self.offLineView.hidden = NO;
        self.account_name.text = self.orderPay.account_data.set_val2;
        self.bank_name.text = self.orderPay.account_data.set_val4;
        self.bank_no.text = self.orderPay.account_data.set_val3;
    }else{
        [self.payType setColorAttributedText:[NSString stringWithFormat:@"支付方式：银联支付"] andChangeStr:@"银联支付" andColor:HXControlBg];
        self.offLineView.hidden = YES;
    }
    [self.payAmount setColorAttributedText:[NSString stringWithFormat:@"订单金额：￥%@",self.orderPay.pay_amount] andChangeStr:[NSString stringWithFormat:@"￥%@",self.orderPay.pay_amount] andColor:HXControlBg];
}

- (NSMutableArray *)controllers {
    if (!_controllers) {
        _controllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    }
    return _controllers;
}

- (IBAction)goHomeClicked:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)lookOrderClicked:(UIButton *)sender {
    GXOrderDetailVC *dvc = [GXOrderDetailVC new];
    dvc.oid = self.orderPay.oid;
    [self.navigationController pushViewController:dvc animated:YES];
}

@end
