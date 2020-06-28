//
//  GXCashNoteDetailVC.m
//  GX
//
//  Created by huaxin-01 on 2020/6/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXCashNoteDetailVC.h"
#import "GXCashNote.h"

@interface GXCashNoteDetailVC ()
@property (nonatomic, strong) GXCashNote *cashNote;
@property (weak, nonatomic) IBOutlet UILabel *cash_title;
@property (weak, nonatomic) IBOutlet UILabel *apply_amount;
@property (weak, nonatomic) IBOutlet UILabel *create_time;
@property (weak, nonatomic) IBOutlet UILabel *approve_time;
@property (weak, nonatomic) IBOutlet UIImageView *pingtai_img;
@property (weak, nonatomic) IBOutlet UIImageView *daozhang_img;
@property (weak, nonatomic) IBOutlet UILabel *apply_status;
@property (weak, nonatomic) IBOutlet UILabel *cash_info;
@property (weak, nonatomic) IBOutlet UIView *pay_money_View;
@property (weak, nonatomic) IBOutlet UIImageView *pay_money_img;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pay_money_view_height;
@end

@implementation GXCashNoteDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"账单详情"];
    [self startShimmer];
    [self getCashNoteDetailRequest];
}
#pragma mark -- 接口请求
-(void)getCashNoteDetailRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"finance_apply_id"] = self.finance_apply_id;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"program/getApplyDetail" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.cashNote = [GXCashNote yy_modelWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleNoteDetailData];
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
-(void)handleNoteDetailData
{
    self.cash_title.text = [NSString stringWithFormat:@"余额提现-到%@(%@)",_cashNote.bank_name,(_cashNote.card_no.length>4)?[_cashNote.card_no substringFromIndex:_cashNote.card_no.length-4]:_cashNote.card_no];
    self.apply_amount.text = [NSString stringWithFormat:@"+￥%@",_cashNote.apply_amount];
    
    // 1待审核；2已通过；3未通过
    if ([_cashNote.apply_status isEqualToString:@"1"]) {
        self.pingtai_img.image = HXGetImage(@"当前进度");
        self.daozhang_img.image = HXGetImage(@"进度");
        self.apply_status.text = @"到账";
        self.apply_status.textColor = UIColorFromRGB(0x999999);
        self.approve_time.text = @"";
    }else if ([_cashNote.apply_status isEqualToString:@""]) {
        self.pingtai_img.image = HXGetImage(@"进度");
        self.daozhang_img.image = HXGetImage(@"当前进度");
        self.apply_status.text = @"提现成功";
        self.apply_status.textColor = UIColorFromRGB(0x1A1A1A);
        self.approve_time.text = _cashNote.approve_time;
    }else{
        self.pingtai_img.image = HXGetImage(@"进度");
        self.daozhang_img.image = HXGetImage(@"进度失败");
        self.apply_status.text = @"提现失败";
        self.apply_status.textColor = UIColorFromRGB(0xFF0000);
        self.approve_time.text = _cashNote.reject_reason;
    }
    [self.cash_info setTextWithLineSpace:12.f withString:[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@",_cashNote.apply_amount,_cashNote.create_time,_cashNote.bank_name,_cashNote.sub_bank_name,_cashNote.card_owner,_cashNote.card_no] withFont:[UIFont fontWithName:@"PingFangSC-Regular" size:13]];
    if (_cashNote.pay_money_img && _cashNote.pay_money_img.length) {
        self.pay_money_View.hidden = NO;
        self.pay_money_view_height.constant = 125.f;
        [self.pay_money_img sd_setImageWithURL:[NSURL URLWithString:_cashNote.pay_money_img]];
    }else{
        self.pay_money_View.hidden = YES;
        self.pay_money_view_height.constant = 15.f;
    }
}
@end
