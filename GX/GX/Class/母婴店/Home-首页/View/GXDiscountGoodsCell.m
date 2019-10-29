//
//  GXDiscountGoodsCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXDiscountGoodsCell.h"
#import "GXHomeData.h"

@interface GXDiscountGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *good_name;
@property (weak, nonatomic) IBOutlet UILabel *price;

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
}
@end
