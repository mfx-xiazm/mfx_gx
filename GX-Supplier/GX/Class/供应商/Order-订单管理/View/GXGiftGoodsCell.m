//
//  GXGiftGoodsCell.m
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXGiftGoodsCell.h"
#import "GXGiftGoods.h"

@interface GXGiftGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (weak, nonatomic) IBOutlet UILabel *gift_name;
@property (weak, nonatomic) IBOutlet UILabel *gift_num;
@end


@implementation GXGiftGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setGiftGoods:(GXGiftGoods *)giftGoods
{
    _giftGoods = giftGoods;
    self.gift_name.text = _giftGoods.gift_name;
    self.gift_num.text = [NSString stringWithFormat:@"x%@",_giftGoods.gift_num];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
