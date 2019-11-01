//
//  GXMemberRankCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMemberRankCell.h"
#import "GXMember.h"

@interface GXMemberRankCell ()
@property (weak, nonatomic) IBOutlet UIImageView *level_img;
@property (weak, nonatomic) IBOutlet UILabel *level_name;
@property (weak, nonatomic) IBOutlet UILabel *level_need;
@property (weak, nonatomic) IBOutlet UILabel *level_coupon;
@property (weak, nonatomic) IBOutlet UILabel *current_level;

@end
@implementation GXMemberRankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setLevel:(GXMemberLevel *)level
{
    _level = level;
    self.level_name.text = _level.level_name;
    
    self.level_img.image = ([_level.condition floatValue] <= [self.price_amount floatValue])?HXGetImage(@"金色奖牌"):HXGetImage(@"灰色奖牌");
    
    self.level_need.text = [NSString stringWithFormat:@"消费控区控价的商品满%@元之后可升级为该等级",_level.condition];
    [self.level_coupon setFontAndColorAttributedText:[NSString stringWithFormat:@"购买控区控价的商品可享 %@ 折优惠",_level.discount] andChangeStr:_level.discount andColor:HXControlBg andFont:[UIFont systemFontOfSize:15]];
    
    self.current_level.hidden = [self.current_level_id isEqualToString:_level.level_id]?NO:YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
