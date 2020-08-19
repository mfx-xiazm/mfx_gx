//
//  GXCashVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXCashVC.h"
#import "GXCashAlert.h"
#import <zhPopupController.h>
#import "NSString+BankInfo.h"
#import "GXCashNoteVC.h"

@interface GXCashVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *card_owner;
@property (weak, nonatomic) IBOutlet UITextField *bank_name;
@property (weak, nonatomic) IBOutlet UITextField *sub_bank_name;
@property (weak, nonatomic) IBOutlet UITextField *card_no;
@property (weak, nonatomic) IBOutlet UITextField *bank_no;
@property (weak, nonatomic) IBOutlet UITextField *apply_amount;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *ableLabel;
@property (nonatomic, strong) zhPopupController *alertPopVC;
@end

@implementation GXCashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"提现"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cashNoteClicked) image:HXGetImage(@"提现记录")];

    self.card_no.delegate = self;
    [self.card_no addTarget:self action:@selector(cardNoChanged:) forControlEvents:UIControlEventEditingChanged];
    self.apply_amount.delegate = self;
    self.ableLabel.text = [NSString stringWithFormat:@"可提现金额：%@",self.cashable];
    hx_weakify(self);
    [self.sureBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
//        if (![strongSelf.card_owner hasText]) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入持卡人姓名"];
//            return NO;
//        }
//        if (![strongSelf.card_no hasText]) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入银行卡号"];
//            return NO;
//        }
//        if (![strongSelf.card_no.text checkCardNo]) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"银行卡号有误"];
//            return NO;
//        }
//        if (![strongSelf.bank_name hasText]) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入银行名称"];
//            return NO;
//        }
//        if (![strongSelf.sub_bank_name hasText]) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入开户网点"];
//            return NO;
//        }
//        if (![strongSelf.bank_no hasText]) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入开户行号"];
//            return NO;
//        }
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
    [self startShimmer];
    [self getBankDataRequest];
}
-(void)cardNoChanged:(UITextField *)card
{
    if ([card hasText]) {
        if (card.text.length < 8) {
            self.bank_name.text = @"";
        }else if (card.text.length == 8){
            NSString *cardName = [[card.text getBankName] componentsSeparatedByString:@"·"].firstObject;
            self.bank_name.text = cardName;
        }
    }else{
        self.bank_name.text = @"";
    }
}
-(void)cashNoteClicked
{
    GXCashNoteVC *nvc = [GXCashNoteVC new];
    [self.navigationController pushViewController:nvc animated:YES];
}
-(void)getBankDataRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"program/getSaleBankData" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.card_owner.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"card_owner"]];
                strongSelf.bank_name.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"bank_name"]];
                strongSelf.sub_bank_name.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"sub_bank_name"]];
                strongSelf.card_no.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"card_no"]];
                strongSelf.bank_no.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"bank_no"]];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)applyCashRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"card_owner"] = self.card_owner.text;
    parameters[@"bank_name"] = self.bank_name.text;
    parameters[@"sub_bank_name"] = self.sub_bank_name.text;
    parameters[@"card_no"] = self.card_no.text;
    parameters[@"bank_no"] = self.bank_no.text;
    parameters[@"apply_amount"] = self.apply_amount.text;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:[[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"2"]?@"index/saveApplyData":@"program/saveApplyData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (strongSelf.cashCall) {
                strongSelf.cashCall();
            }
            [strongSelf showCashAlert];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)showCashAlert
{
    GXCashAlert *alert = [GXCashAlert loadXibView];
    alert.hxn_width = HX_SCREEN_WIDTH - 60*2;
    alert.hxn_height = 180;
    hx_weakify(self);
    alert.cashKnowCall = ^{
        hx_strongify(weakSelf);
        [strongSelf.alertPopVC dismiss];
        [strongSelf.navigationController popViewControllerAnimated:YES];
    };
    self.alertPopVC = [[zhPopupController alloc] initWithView:alert size:alert.bounds.size];
    self.alertPopVC.dismissOnMaskTouched = NO;
    [self.alertPopVC show];
}
//参数一：range，要被替换的字符串的range，如果是新输入的，就没有字符串被替换，range.length = 0
//参数二：替换的字符串，即键盘即将输入或者即将粘贴到textField的string
//返回值为BOOL类型，YES表示允许替换，NO表示不允许
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    if (textField == self.card_no) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }else{
       //新输入的
        if (string.length == 0) {
            return YES;
        }

       //第一个参数，被替换字符串的range
       //第二个参数，即将键入或者粘贴的string
       //返回的是改变过后的新str，即textfield的新的文本内容
        NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
       if (checkStr.length > 0) {
           if ([checkStr doubleValue] == 0) {
             //判断首位不能为零
               return NO;
           }
       }
        //正则表达式（只支持两位小数）
        NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
       //判断新的文本内容是否符合要求
        return [self isValid:checkStr withRegex:regex];
    }
}

//检测改变过的文本是否匹配正则表达式，如果匹配表示可以键入，否则不能键入
- (BOOL) isValid:(NSString*)checkStr withRegex:(NSString*)regex
{
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}
@end
