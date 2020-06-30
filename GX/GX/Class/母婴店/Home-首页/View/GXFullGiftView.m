//
//  GXFullGiftView.m
//  GX
//
//  Created by huaxin-01 on 2020/6/11.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXFullGiftView.h"
#import "GXGoodsDetail.h"
#import "GXCartData.h"
#import "GXConfirmOrder.h"

@interface GXFullGiftView ()
@property (weak, nonatomic) IBOutlet UILabel *benPinTxt;
@property (weak, nonatomic) IBOutlet UILabel *qiTatxt;

@end
@implementation GXFullGiftView

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self bezierPathByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
}
-(void)setGift_rule:(NSArray<GXGoodsGiftRule *> *)gift_rule
{
    _gift_rule = gift_rule;
    NSMutableString *benpin = [NSMutableString string];
    NSMutableString *qita = [NSMutableString string];
    for (GXGoodsGiftRule *rule in _gift_rule) {
        if ([rule.gift_type isEqualToString:@"1"]) {// 本品
            if (benpin.length) {
               [benpin appendFormat:@"，%@",[NSString stringWithFormat:@"买%@赠%@",rule.begin_num,rule.gift_num]];
            }else{
                [benpin appendFormat:@"%@",[NSString stringWithFormat:@"买%@赠%@",rule.begin_num,rule.gift_num]];
            }
        }else{// 其他
            if (qita.length) {
                [qita appendFormat:@"\n%@",[NSString stringWithFormat:@"买%@搭赠%@%@",rule.begin_num,rule.gift_num,rule.goods_name]];
            }else{
                [qita appendFormat:@"%@",[NSString stringWithFormat:@"买%@搭赠%@%@",rule.begin_num,rule.gift_num,rule.goods_name]];
            }
        }
    }
    if (benpin.length) {
        [self.benPinTxt setTextWithLineSpace:10 withString:benpin withFont:[UIFont systemFontOfSize:13]];
    }else{
        self.benPinTxt.text = @"无";
    }
    if (qita.length) {
        [self.qiTatxt setTextWithLineSpace:10 withString:qita withFont:[UIFont systemFontOfSize:13]];
    }else{
        self.qiTatxt.text = @"无";
    }
}
-(void)setCart_gift_rule:(NSArray<GXCartGoodsGift *> *)cart_gift_rule
{
    _cart_gift_rule = cart_gift_rule;
    
    NSMutableString *benpin = [NSMutableString string];
    NSMutableString *qita = [NSMutableString string];
    for (GXCartGoodsGift *rule in _cart_gift_rule) {
        if ([rule.gift_type isEqualToString:@"1"]) {// 本品
            if (benpin.length) {
               [benpin appendFormat:@"，%@",[NSString stringWithFormat:@"买%@赠%@",rule.begin_num,rule.gift_num]];
            }else{
                [benpin appendFormat:@"%@",[NSString stringWithFormat:@"买%@赠%@",rule.begin_num,rule.gift_num]];
            }
        }else{// 其他
            if (qita.length) {
                [qita appendFormat:@"\n%@",[NSString stringWithFormat:@"买%@搭赠%@%@",rule.begin_num,rule.gift_num,rule.goods_name]];
            }else{
                [qita appendFormat:@"%@",[NSString stringWithFormat:@"买%@搭赠%@%@",rule.begin_num,rule.gift_num,rule.goods_name]];
            }
        }
    }
    if (benpin.length) {
        [self.benPinTxt setTextWithLineSpace:10 withString:benpin withFont:[UIFont systemFontOfSize:13]];
    }else{
        self.benPinTxt.text = @"无";
    }
    if (qita.length) {
        [self.qiTatxt setTextWithLineSpace:10 withString:qita withFont:[UIFont systemFontOfSize:13]];
    }else{
        self.qiTatxt.text = @"无";
    }
}
-(void)setGift_data:(NSArray<GXConfirmGoodsGift *> *)gift_data
{
    _gift_data = gift_data;
    
    NSMutableString *benpin = [NSMutableString string];
    NSMutableString *qita = [NSMutableString string];
    for (GXConfirmGoodsGift *rule in _gift_data) {
        if ([rule.gift_type isEqualToString:@"1"]) {// 本品
            if (benpin.length) {
               [benpin appendFormat:@"，%@",[NSString stringWithFormat:@"%@买%@赠%@",rule.sale_goods,rule.begin_num,rule.gift_num]];
            }else{
                [benpin appendFormat:@"%@",[NSString stringWithFormat:@"%@买%@赠%@",rule.sale_goods,rule.begin_num,rule.gift_num]];
            }
        }else{// 其他
            if (qita.length) {
                [qita appendFormat:@"\n%@",[NSString stringWithFormat:@"%@买%@搭赠%@%@",rule.sale_goods,rule.begin_num,rule.gift_num,rule.goods_name]];
            }else{
                [qita appendFormat:@"%@",[NSString stringWithFormat:@"%@买%@搭赠%@%@",rule.sale_goods,rule.begin_num,rule.gift_num,rule.goods_name]];
            }
        }
    }
    if (benpin.length) {
        [self.benPinTxt setTextWithLineSpace:10 withString:benpin withFont:[UIFont systemFontOfSize:13]];
    }else{
        self.benPinTxt.text = @"无";
    }
    if (qita.length) {
        [self.qiTatxt setTextWithLineSpace:10 withString:qita withFont:[UIFont systemFontOfSize:13]];
    }else{
        self.qiTatxt.text = @"无";
    }
}
- (IBAction)closeClicked:(UIButton *)sender {
    if (self.closeClickedCall) {
        self.closeClickedCall();
    }
}

@end
