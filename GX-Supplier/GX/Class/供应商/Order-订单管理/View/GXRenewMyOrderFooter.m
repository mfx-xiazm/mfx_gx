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
-(void)setPOrder:(GXMyOrder *)pOrder
{
    _pOrder = pOrder;
    self.tuiLabel.hidden = YES;
    self.tuiAmount.hidden = YES;
    self.total_price.text = [NSString stringWithFormat:@"￥%@",_pOrder.pay_amount];
}
-(void)setPRefund:(GXMyRefund *)pRefund
{
    _pRefund = pRefund;
    self.tuiLabel.hidden = NO;
    self.tuiAmount.hidden = NO;
    
    self.tuiAmount.text = [NSString stringWithFormat:@"￥%@",(_pRefund.return_amount && _pRefund.return_amount.length)?_pRefund.return_amount:_pRefund.pay_amount];
    self.total_price.text = [NSString stringWithFormat:@"￥%@",_pRefund.pay_amount];
}
- (IBAction)orderHandleClicked:(UIButton *)sender {
    if (self.orderHandleCall) {
        self.orderHandleCall(sender.tag);
    }
}
@end
