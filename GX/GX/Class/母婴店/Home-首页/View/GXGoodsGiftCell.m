//
//  GXGoodsGiftCell.m
//  GX
//
//  Created by huaxin-01 on 2020/6/11.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXGoodsGiftCell.h"
#import "GXGoodsDetail.h"

@interface GXGoodsGiftCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *ruleLabels;

@end
@implementation GXGoodsGiftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setGift_rule:(NSArray<GXGoodsGiftRule *> *)gift_rule
{
    _gift_rule = gift_rule;
    self.name.text = @"商品搭赠";
    for (int i=0; i<self.ruleLabels.count; i++) {
        UILabel *ruleL = self.ruleLabels[i];
        if ((i+1) <= _gift_rule.count) {
            GXGoodsGiftRule *rule = _gift_rule[i];
            if ([rule.gift_type isEqualToString:@"1"]) {//本品
                ruleL.text = [NSString stringWithFormat:@"  买%@赠%@  ",rule.begin_num,rule.gift_num];
            }else{
                ruleL.text = [NSString stringWithFormat:@"  买%@搭赠%@%@个  ",rule.begin_num,rule.goods_name,rule.gift_num];
            }
            ruleL.textColor = UIColorFromRGB(0xFF8A00);
            ruleL.backgroundColor = UIColorFromRGB(0xFFE8CC);
        }else{
            ruleL.text = @"";
            ruleL.hidden = YES;
        }
    }
}
-(void)setRebate:(NSArray<GXGoodsRebate *> *)rebate
{
    _rebate = rebate;
    self.name.text = @"品牌返利";
    for (int i=0; i<self.ruleLabels.count; i++) {
        UILabel *ruleL = self.ruleLabels[i];
        if ((i+1) <= _rebate.count) {
            GXGoodsRebate *rebate = _rebate[i];
            ruleL.text = [NSString stringWithFormat:@"  满%@返%@%%  ",rebate.begin_price,rebate.percent];
            ruleL.textColor = UIColorFromRGB(0xFF001D);
            ruleL.backgroundColor = HXRGBAColor(234,74,92,0.2);
        }else{
            ruleL.text = @"";
            ruleL.hidden = YES;
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
