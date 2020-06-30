//
//  GXPresellCell.m
//  GX
//
//  Created by huaxin-01 on 2020/6/17.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXPresellCell.h"
#import "GXPreSales.h"
#import "OYCountDownManager.h"

@interface GXPresellCell ()
@property (weak, nonatomic) IBOutlet UIImageView *flag_img;
@property (weak, nonatomic) IBOutlet UILabel *goods_anme;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *sale_num;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;

@end
@implementation GXPresellCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
// 代码创建
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:OYCountDownNotification object:nil];
    }
    return self;
}

// xib创建
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:OYCountDownNotification object:nil];
    }
    return self;
}
-(void)setPreSale:(GXPreSales *)preSale
{
    _preSale = preSale;
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_preSale.cover_img]];
    // 状态：1未开始，2预售中 3已结束
    if ([_preSale.sell_status isEqualToString:@"1"]) {
        self.flag_img.hidden = NO;
        self.flag_img.image = HXGetImage(@"即将开始_1");
        self.sale_num.hidden = YES;
    }else if ([_preSale.sell_status isEqualToString:@"2"]) {
        self.flag_img.hidden = NO;
        self.flag_img.image = HXGetImage(@"火热预售");
        self.sale_num.hidden = NO;
        self.sale_num.text = [NSString stringWithFormat:@"销量：%@",_preSale.sell_num];
    }else{
        self.flag_img.hidden = YES;
        self.sale_num.hidden = NO;
        self.sale_num.text = [NSString stringWithFormat:@"销量：%@",_preSale.sell_num];
    }
    self.goods_anme.text = _preSale.goods_name;
    if ([_preSale.control_type isEqualToString:@"1"]) {
        if ([_preSale.min_price floatValue] == [_preSale.max_price floatValue]) {
            self.price.text = [NSString stringWithFormat:@"￥%@",_preSale.min_price];
        }else{
            self.price.text = [NSString stringWithFormat:@"￥%@-￥%@",_preSale.min_price,_preSale.max_price];
        }
    }else{
        self.price.text = [NSString stringWithFormat:@"￥%@",_preSale.min_price];
    }
    if ([_preSale.sell_status isEqualToString:@"1"] || [_preSale.sell_status isEqualToString:@"2"]) {
        // 手动刷新数据
        [self countDownNotification];
    }
}
#pragma mark - 倒计时通知回调
- (void)countDownNotification {
    /// 判断是否需要倒计时 -- 可能有的cell不需要倒计时,根据真实需求来进行判断
    if (0) {
        return;
    }
    /// 计算倒计时
    GXPreSales *model = self.preSale;
    NSInteger timeInterval;
    if (model.countDownSource) {
        timeInterval = [kCountDownManager timeIntervalWithIdentifier:model.countDownSource];
    }else {
        timeInterval = kCountDownManager.timeInterval;
    }
    NSInteger countDown = model.count - timeInterval;
    /// 当倒计时到了进行回调
    if (countDown <= 0) {
        // 状态：1未开始，2预售中 3已结束
        if ([_preSale.sell_status isEqualToString:@"1"]) {
            _preSale.sell_status = @"2";
        }else if ([_preSale.sell_status isEqualToString:@"2"]) {
            _preSale.sell_status = @"3";
        }
        // 回调给控制器
        if (self.countDownZero) {
            self.countDownZero(model);
        }
        return;
    }
    /// 重新赋值
    if ([_preSale.sell_status isEqualToString:@"1"]) {
        self.time.text = [NSString stringWithFormat:@"距开始%02zd:%02zd:%02zd", countDown/3600, (countDown/60)%60, countDown%60];
    }else if ([_preSale.sell_status isEqualToString:@"2"]) {
        self.time.text = [NSString stringWithFormat:@"距结束%02zd:%02zd:%02zd", countDown/3600, (countDown/60)%60, countDown%60];
    }else{
        self.time.text = @"已结束";
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
