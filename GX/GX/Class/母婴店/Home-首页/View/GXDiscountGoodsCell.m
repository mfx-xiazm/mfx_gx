//
//  GXDiscountGoodsCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXDiscountGoodsCell.h"
#import "GXHomeData.h"
#import "GXDayDiscount.h"

@interface GXDiscountGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *good_name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *handleBtn;
@property (weak, nonatomic) IBOutlet UILabel *market_price;

@end
@implementation GXDiscountGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDiscount:(GYHomeDiscount *)discount
{
    _discount = discount;
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_discount.cover_img]];
    self.good_name.text = _discount.goods_name;
    self.price.text = [NSString stringWithFormat:@"￥%@",_discount.price];
    /** 1未开始 2进行中 3已结束 4暂停 */
    if ([_discount.rushbuy_status isEqualToString:@"2"]) {
        [self.handleBtn setBackgroundColor:UIColorFromRGB(0xFF9F08)];
        [self.handleBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
        [self.handleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if ([_discount.rushbuy_status isEqualToString:@"3"]) {
        [self.handleBtn setBackgroundColor:UIColorFromRGB(0xCCCCCC)];
        [self.handleBtn setTitle:@"已结束" forState:UIControlStateNormal];
        [self.handleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [self.handleBtn setBackgroundColor:HXRGBAColor(255, 138, 0, 0.3)];
        [self.handleBtn setTitle:@"未开始" forState:UIControlStateNormal];
        [self.handleBtn setTitleColor:UIColorFromRGB(0xFF9F08) forState:UIControlStateNormal];
    }
}
-(void)setDayDiscount:(GXDayDiscount *)dayDiscount
{
    _dayDiscount = dayDiscount;
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_dayDiscount.cover_img]];
    self.good_name.text = _dayDiscount.goods_name;
    self.price.text = [NSString stringWithFormat:@"￥%@",_dayDiscount.price];
    
    self.market_price.hidden = NO;
    [self.market_price setLabelUnderline:[NSString stringWithFormat:@"￥%@",_dayDiscount.suggest_price]];
    /** 1未开始 2进行中 3已结束 4暂停 */
    if ([_dayDiscount.rushbuy_status isEqualToString:@"2"]) {
        [self.handleBtn setBackgroundColor:UIColorFromRGB(0xFF9F08)];
        [self.handleBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
        [self.handleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if ([_dayDiscount.rushbuy_status isEqualToString:@"3"]) {
        [self.handleBtn setBackgroundColor:UIColorFromRGB(0xCCCCCC)];
        [self.handleBtn setTitle:@"已结束" forState:UIControlStateNormal];
        [self.handleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [self.handleBtn setBackgroundColor:HXRGBAColor(255, 138, 0, 0.3)];
        [self.handleBtn setTitle:@"未开始" forState:UIControlStateNormal];
        [self.handleBtn setTitleColor:UIColorFromRGB(0xFF9F08) forState:UIControlStateNormal];
    }
}
@end
