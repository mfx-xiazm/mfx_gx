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
#import "GXCategoryGoods.h"
#import "GXMyCollect.h"

@interface GXDiscountGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *good_name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *handleBtn;
@property (weak, nonatomic) IBOutlet UILabel *market_price;
@property (weak, nonatomic) IBOutlet UILabel *sale_num;

@end
@implementation GXDiscountGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)discountClicked:(UIButton *)sender {
    if (self.discountClickedCall) {
        self.discountClickedCall();
    }
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
    }else if ([_discount.rushbuy_status isEqualToString:@"1"]) {
        [self.handleBtn setBackgroundColor:HXRGBAColor(255, 138, 0, 0.3)];
        [self.handleBtn setTitle:@"未开始" forState:UIControlStateNormal];
        [self.handleBtn setTitleColor:UIColorFromRGB(0xFF9F08) forState:UIControlStateNormal];
    }else{
        [self.handleBtn setBackgroundColor:UIColorFromRGB(0xCCCCCC)];
        [self.handleBtn setTitle:@"已结束" forState:UIControlStateNormal];
        [self.handleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    }else if ([_dayDiscount.rushbuy_status isEqualToString:@"1"]) {
        [self.handleBtn setBackgroundColor:HXRGBAColor(255, 138, 0, 0.3)];
        [self.handleBtn setTitle:@"未开始" forState:UIControlStateNormal];
        [self.handleBtn setTitleColor:UIColorFromRGB(0xFF9F08) forState:UIControlStateNormal];
    }else{
        [self.handleBtn setBackgroundColor:UIColorFromRGB(0xCCCCCC)];
        [self.handleBtn setTitle:@"已结束" forState:UIControlStateNormal];
        [self.handleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
-(void)setGoods:(GXCategoryGoods *)goods
{
    _goods = goods;
    
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_goods.cover_img]];
    self.good_name.text = _goods.goods_name;
    if ([_goods.control_type isEqualToString:@"1"]) {
        if ([_goods.min_price floatValue] == [_goods.max_price floatValue]) {
            self.price.text = [NSString stringWithFormat:@"￥%@",_goods.min_price];
        }else{
            self.price.text = [NSString stringWithFormat:@"￥%@-￥%@",_goods.min_price,_goods.max_price];
        }
    }else{
        self.price.text = [NSString stringWithFormat:@"￥%@",_goods.min_price];
    }
    self.market_price.hidden = YES;
    self.handleBtn.hidden = YES;
    self.sale_num.hidden = NO;
    self.sale_num.text = [NSString stringWithFormat:@"销量：%@",_goods.sale_num];
}

-(void)setCollect:(GXMyCollect *)collect
{
    _collect = collect;
    
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_collect.cover_img]];
    self.good_name.text = _collect.goods_name;
    if ([_collect.control_type isEqualToString:@"1"]) {
        if ([_collect.min_price floatValue] == [_collect.max_price floatValue]) {
            self.price.text = [NSString stringWithFormat:@"￥%@",_collect.min_price];
        }else{
            self.price.text = [NSString stringWithFormat:@"￥%@-￥%@",_collect.min_price,_collect.max_price];
        }
    }else{
        self.price.text = [NSString stringWithFormat:@"￥%@",_collect.min_price];
    }
    self.market_price.hidden = YES;
    self.handleBtn.hidden = YES;
    self.sale_num.hidden = YES;
}
@end
