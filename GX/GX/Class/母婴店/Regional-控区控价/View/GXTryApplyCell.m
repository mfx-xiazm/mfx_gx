//
//  GXTryApplyCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXTryApplyCell.h"
#import "GXTryGoods.h"

@interface GXTryApplyCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *good_name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@end

@implementation GXTryApplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setGoods:(GXTryGoods *)goods
{
    _goods = goods;
    
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_goods.cover_img]];
    self.good_name.text = _goods.goods_name;
    if ([_goods.control_type isEqualToString:@"1"]) {
        self.price.text = [NSString stringWithFormat:@"￥%@-￥%@",_goods.min_price,_goods.max_price];
    }else{
        self.price.text = [NSString stringWithFormat:@"￥%@",_goods.min_price];
    }
}
- (IBAction)buyClicked:(UIButton *)sender {
    if (self.getTryCall) {
        self.getTryCall();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
