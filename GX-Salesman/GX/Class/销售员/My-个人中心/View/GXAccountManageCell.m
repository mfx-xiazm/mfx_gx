//
//  GXAccountManageCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXAccountManageCell.h"
#import "GXFinanceLog.h"

@interface GXAccountManageCell ()
@property (weak, nonatomic) IBOutlet UILabel *order_no;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *left_amount;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UIView *top_view;

@end
@implementation GXAccountManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setLog:(GXFinanceLog *)log
{
    _log = log;
    if (_log.finance_log_type <= 5) {
        self.top_view.hidden = NO;
        self.order_no.text = [NSString stringWithFormat:@"%@",_log.orderInfo.order_no];
        self.time.text = _log.create_time;
    }else{
        self.top_view.hidden = YES;
    }
        
    if (_log.finance_log_type <= 5) {
        self.desc.text = _log.orderInfo.goods_name;

        /*
         if ([[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"2"]) {
         self.type.text = @"订单收入";
         }else{
         self.type.text = @"订单佣金";
         }
         */
        // 0 终端门店订单的提成佣金;1平台订单收入；2供应商订单收入 3供应商订单的平台抽佣；4推荐供应商的奖励佣金；5终端门店订单的提成佣金
        if (_log.finance_log_type == 0) {
            self.type.text = @"平台订单的提成佣金";
        }else if (_log.finance_log_type == 1) {
            self.type.text = @"平台订单收入";
        }else if (_log.finance_log_type == 2) {
            self.type.text = @"供应商订单收入";
        }else if (_log.finance_log_type == 3) {
            self.type.text = @"供应商订单的平台抽佣";
        }else if (_log.finance_log_type == 4) {
            self.type.text = @"供应商订单推荐供应商佣金";
        }else{
            self.type.text = @"供应商订单推荐母婴店佣金";
        }
        
        self.left_amount.textColor = HXControlBg;
        self.left_amount.text = [NSString stringWithFormat:@"￥%@",_log.orderInfo.pay_amount];
        self.amount.text = [NSString stringWithFormat:@"+%@",_log.amount];
    }else if (_log.finance_log_type == 6) {
        self.desc.text = @"提现驳回";
        
        self.type.text = @"提现驳回";
        self.left_amount.textColor = UIColorFromRGB(0xCCCCCC);
        self.left_amount.text = _log.create_time;
        self.amount.text = [NSString stringWithFormat:@"%@",_log.amount];
    }else{
        self.desc.text = @"余额提现";
        
        self.type.text = @"余额提现";
        self.left_amount.textColor = UIColorFromRGB(0xCCCCCC);
        self.left_amount.text = _log.create_time;
        self.amount.text = [NSString stringWithFormat:@"%@",_log.amount];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
