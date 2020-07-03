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
        
        self.desc.text = _log.orderInfo.goods_name;

        // 0 终端门店订单的提成佣金;1平台订单收入；2供应商订单收入 3供应商订单的平台抽佣；4推荐供应商的奖励佣金；5终端门店订单的提成佣金 6 提现申请驳回  20提现申请提交扣除提现金额 30 供应商订单收货时因销售员下级推荐母婴店的抽成； 31 供应商订单收货时因销售员下级的下级推荐母婴店的抽成； 32供应商订单因推荐业务员的抽成 40退货后供应商的扣减；41退货后平台抽佣的扣减；42退货后推荐供应商的业务员的扣减；43退后后推荐母婴店的业务员扣减；44退货后推荐母婴店的业务员的上级的扣减；45退后后推荐母婴店的业务员的上级的上级的扣减；46退后后推荐母婴店的业务员的推荐人(业务员)的扣减
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
        self.top_view.hidden = YES;

        self.desc.text = @"提现驳回";
        
        self.type.text = @"提现驳回";
        self.left_amount.textColor = UIColorFromRGB(0xCCCCCC);
        self.left_amount.text = _log.create_time;
        self.amount.text = [NSString stringWithFormat:@"%@",_log.amount];
    }else if (_log.finance_log_type == 20) {
        self.top_view.hidden = YES;

        self.desc.text = @"余额提现";
        
        self.type.text = @"余额提现";
        self.left_amount.textColor = UIColorFromRGB(0xCCCCCC);
        self.left_amount.text = _log.create_time;
        self.amount.text = [NSString stringWithFormat:@"%@",_log.amount];
    }else if (_log.finance_log_type >= 30 && _log.finance_log_type <= 32) {
        self.top_view.hidden = NO;
        self.order_no.text = [NSString stringWithFormat:@"%@",_log.orderInfo.order_no];
        self.time.text = _log.create_time;
        
        self.desc.text = _log.orderInfo.goods_name;

        // 0 终端门店订单的提成佣金;1平台订单收入；2供应商订单收入 3供应商订单的平台抽佣；4推荐供应商的奖励佣金；5终端门店订单的提成佣金 6 提现申请驳回  20提现申请提交扣除提现金额 30 供应商订单收货时因销售员下级推荐母婴店的抽成； 31 供应商订单收货时因销售员下级的下级推荐母婴店的抽成； 32供应商订单因推荐业务员的抽成 40退货后供应商的扣减；41退货后平台抽佣的扣减；42退货后推荐供应商的业务员的扣减；43退后后推荐母婴店的业务员扣减；44退货后推荐母婴店的业务员的上级的扣减；45退后后推荐母婴店的业务员的上级的上级的扣减；46退后后推荐母婴店的业务员的推荐人(业务员)的扣减
        if (_log.finance_log_type == 30) {
            self.type.text = @"销售员下级推荐佣金";
        }else if (_log.finance_log_type == 31) {
            self.type.text = @"销售员下级的下级推荐佣金";
        }else{
            self.type.text = @"推荐业务员的佣金";
        }
        
        self.left_amount.textColor = HXControlBg;
        self.left_amount.text = [NSString stringWithFormat:@"￥%@",_log.orderInfo.pay_amount];
        self.amount.text = [NSString stringWithFormat:@"+%@",_log.amount];
    }else{
        self.top_view.hidden = NO;
        self.order_no.text = [NSString stringWithFormat:@"%@",_log.orderInfo.order_no];
        self.time.text = _log.create_time;
        
        self.desc.text = _log.orderInfo.goods_name;

        // 0 终端门店订单的提成佣金;1平台订单收入；2供应商订单收入 3供应商订单的平台抽佣；4推荐供应商的奖励佣金；5终端门店订单的提成佣金 6 提现申请驳回  20提现申请提交扣除提现金额 30 供应商订单收货时因销售员下级推荐母婴店的抽成； 31 供应商订单收货时因销售员下级的下级推荐母婴店的抽成； 32供应商订单因推荐业务员的抽成 40退货后供应商的扣减；41退货后平台抽佣的扣减；42退货后推荐供应商的业务员的扣减；43退后后推荐母婴店的业务员扣减；44退货后推荐母婴店的业务员的上级的扣减；45退后后推荐母婴店的业务员的上级的上级的扣减；46退后后推荐母婴店的业务员的推荐人(业务员)的扣减
        if (_log.finance_log_type == 40) {
            self.type.text = @"退货后供应商的扣减";
        }else if (_log.finance_log_type == 41) {
            self.type.text = @"退货后平台扣减";
        }else if (_log.finance_log_type == 42) {
            self.type.text = @"退货后推荐供应商的业务员的扣减";
        }else if (_log.finance_log_type == 43) {
            self.type.text = @"退货后推荐母婴店的业务员扣减";
        }else if (_log.finance_log_type == 44) {
            self.type.text = @"退货后推荐母婴店的业务员的上级的扣减";
        }else if (_log.finance_log_type == 45) {
            self.type.text = @"退货后推荐母婴店的业务员的上级的上级的扣减";
        }else {
            self.type.text = @"退货后推荐母婴店的业务员的推荐人(业务员)的扣减";
        }

        self.left_amount.textColor = HXControlBg;
        self.left_amount.text = [NSString stringWithFormat:@"￥%@",_log.orderInfo.pay_amount];
        self.amount.text = [NSString stringWithFormat:@"%@",_log.amount];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
