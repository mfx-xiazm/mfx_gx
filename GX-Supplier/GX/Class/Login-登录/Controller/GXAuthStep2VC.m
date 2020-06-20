//
//  GXAuthStep2VC.m
//  GX
//
//  Created by 夏增明 on 2020/2/14.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXAuthStep2VC.h"
#import "GXAuthStep4VC.h"
#import "UITextField+GYExpand.h"

@interface GXAuthStep2VC ()
@property (nonatomic, weak) IBOutlet UITextField *account_name;//账户姓名
@property (nonatomic, weak) IBOutlet UITextField *account_bank;//开户银行
@property (nonatomic, weak) IBOutlet UITextField *account_code;//银行卡号
@property (nonatomic, weak) IBOutlet UITextField *account_dot;//开户网点
@property (nonatomic, weak) IBOutlet UITextField *account_phone;//预留银行手机号

@property (nonatomic, weak) IBOutlet UIButton *submitBtn;//提交

@end

@implementation GXAuthStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"签约"];
    hx_weakify(self);
    [self.account_phone lengthLimit:^{
        hx_strongify(weakSelf);
        if (strongSelf.account_phone.text.length > 11) {
            strongSelf.account_phone.text = [strongSelf.account_phone.text substringToIndex:11];
        }
    }];
    [self.submitBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.account_name hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入持卡人姓名"];
            return NO;
        }
        if (![strongSelf.account_bank hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入开户银行"];
            return NO;
        }
        if (![strongSelf.account_code hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入银行账号"];
            return NO;
        }
        if (![strongSelf.account_dot hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入开户网点"];
            return NO;
        }
        if (![strongSelf.account_phone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入银行预留手机号"];
            return NO;
        }
        if (strongSelf.account_phone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机号格式有误"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf submitRequest:button];
    }];
}
-(void)submitRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = self.uid;//用户id
    parameters[@"token"] = self.token;//用户验证
    parameters[@"account_name"] = self.account_name.text;//账户姓名
    parameters[@"account_bank"] = self.account_bank.text;//开户银行
    parameters[@"account_code"] = self.account_code.text;//银行卡号
    parameters[@"account_dot"] = self.account_dot.text;//开户网点
    parameters[@"account_phone"] = self.account_phone.text;//预留银行手机号

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/supplierAuthentication" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"提交" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                GXAuthStep4VC *svc = [GXAuthStep4VC new];
                svc.uid = strongSelf.uid;
                svc.token = strongSelf.token;
                [strongSelf.navigationController pushViewController:svc animated:YES];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"提交" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}

@end
