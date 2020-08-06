//
//  GXUnionAuthVC.m
//  GX
//
//  Created by huaxin-01 on 2020/8/6.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXUnionAuthVC.h"
#import "GXWebContentVC.h"

@interface GXUnionAuthVC ()
@property (nonatomic, weak) IBOutlet UITextField *payment;//打款金额
@property (nonatomic, weak) IBOutlet UIButton *submitBtn;//提交
@end

@implementation GXUnionAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"对公账户校验"];
    
    hx_weakify(self);
    [self.submitBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.payment hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入打款金额"];
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
    parameters[@"seaType"] = @"4";
    parameters[@"ums_reg_id"] = self.ums_reg_id;
    parameters[@"company_account"] = self.company_account;
    parameters[@"trans_amt"] = self.payment.text;

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"index/signData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"提交" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"res_code"] isEqualToString:@"0000"]) {
            [strongSelf getSignWebDataRequest:@"6"];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"res_msg"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"提交" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getSignWebDataRequest:(NSString *)seaType
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"seaType"] = seaType;
    parameters[@"ums_reg_id"] = self.ums_reg_id;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"index/signData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            GXWebContentVC *wvc = [GXWebContentVC new];
            wvc.isNeedRequest = NO;
            wvc.url = responseObject[@"data"];
            [strongSelf.navigationController pushViewController:wvc animated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
