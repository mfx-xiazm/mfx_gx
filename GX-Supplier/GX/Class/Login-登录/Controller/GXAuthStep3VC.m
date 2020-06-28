//
//  GXAuthStep3VC.m
//  GX
//
//  Created by 夏增明 on 2020/2/14.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXAuthStep3VC.h"
#import "GXAuthStep2VC.h"
#import "GXAuthStep4VC.h"

@interface GXAuthStep3VC ()
/** vc控制器 */
@property (nonatomic,strong) NSMutableArray *controllers;
@property (nonatomic, weak) IBOutlet UITextField *payment;//打款金额
@property (nonatomic, weak) IBOutlet UIButton *submitBtn;//提交
@end

@implementation GXAuthStep3VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"签约"];

    hx_weakify(self);
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[GXAuthStep2VC class]]) {
            hx_strongify(weakSelf);
            [strongSelf.controllers removeObjectAtIndex:idx];
        }
    }];
    [self.navigationController setViewControllers:self.controllers];
   
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
- (NSMutableArray *)controllers {
    if (!_controllers) {
        _controllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    }
    return _controllers;
}

-(void)submitRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = self.uid;//用户id
    parameters[@"token"] = self.token;//用户验证
    parameters[@"payment"] = self.payment.text;//打款金额

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"index/platformPayment" parameters:parameters success:^(id responseObject) {
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
