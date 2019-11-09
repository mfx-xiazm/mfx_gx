//
//  GXCashVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXCashVC.h"

@interface GXCashVC ()
@property (weak, nonatomic) IBOutlet UITextField *card_owner;
@property (weak, nonatomic) IBOutlet UITextField *bank_name;
@property (weak, nonatomic) IBOutlet UITextField *card_no;
@property (weak, nonatomic) IBOutlet UITextField *apply_amount;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *ableLabel;

@end

@implementation GXCashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"提现"];
    
    self.ableLabel.text = [NSString stringWithFormat:@"可提现金额：%@",self.cashable];
    hx_weakify(self);
    [self.sureBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.card_owner hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入持卡人姓名"];
            return NO;
        }
        if (![strongSelf.bank_name hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入银行名称"];
            return NO;
        }
        if (![strongSelf.card_no hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入银行卡号"];
            return NO;
        }
        if (![strongSelf.apply_amount hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入提现金额"];
            return NO;
        }
        if ([strongSelf.apply_amount.text floatValue] > [self.cashable floatValue]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"可提现金额不足"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf applyCashRequest:button];
    }];
}

-(void)applyCashRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"card_owner"] = self.card_owner.text;
    parameters[@"bank_name"] = self.bank_name.text;
    parameters[@"card_no"] = self.card_no.text;
    parameters[@"apply_amount"] = self.apply_amount.text;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:[[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"2"]?@"index/saveApplyData":@"program/saveApplyData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
