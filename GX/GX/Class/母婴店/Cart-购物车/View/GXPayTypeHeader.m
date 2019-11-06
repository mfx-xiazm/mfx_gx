//
//  GXPayTypeHeader.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXPayTypeHeader.h"
#import "GXOrderPay.h"
#import "XTimer.h"

@interface GXPayTypeHeader ()
/** 倒计时 */
@property (nonatomic,strong) XTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *minte;
@property (weak, nonatomic) IBOutlet UILabel *second;
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *payAmount;

@end
@implementation GXPayTypeHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)setOrderPay:(GXOrderPay *)orderPay
{
    _orderPay = orderPay;
    
    [self countTimeDown];
    if (!self.timer) {
        self.timer = [XTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTimeDown) userInfo:nil repeats:YES];
    }
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:_orderPay.cover_img]];
    self.orderNum.text = [NSString stringWithFormat:@"共%@件商品",_orderPay.order_num];
    self.payAmount.text = [NSString stringWithFormat:@"￥%@",_orderPay.pay_amount];
}
-(void)countTimeDown
{
    if (_orderPay.countDown >0) {
        //NSString *str_day = [NSString stringWithFormat:@"%02ld",(self.shopSeckill.countDown/3600)/24];
        //NSString *str_hour = [NSString stringWithFormat:@"%02ld",_orderPay.countDown/3600%24];
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(_orderPay.countDown%(60*60))/60];
        NSString *str_second = [NSString stringWithFormat:@"%02ld",_orderPay.countDown%60];
        //设置文字显示 根据自己需求设置
        self.minte.text = str_minute;
        self.second.text = str_second;
        _orderPay.countDown -= 1;
    }else{
        // 移除倒计时，发出通知并刷新页面
        _orderPay.countDown = 0;
        [self.timer invalidate];
        self.timer = nil;
        
//        if (self.countDownCall) {
//            self.countDownCall();
//        }
    }
}
-(void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
@end
