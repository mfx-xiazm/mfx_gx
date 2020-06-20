//
//  GXDiscountGoodsCell2.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXDiscountGoodsCell2.h"
#import "GXHomeData.h"

@interface GXDiscountGoodsCell2 ()
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
@implementation GXDiscountGoodsCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDiscount:(GYHomeDiscount *)discount
{
    _discount = discount;
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_discount.cover_img]];
    self.goods_name.text = _discount.goods_name;
    [self.price setColorAttributedText:[NSString stringWithFormat:@"￥%@起",_discount.price] andChangeStr:@"起" andColor:[UIColor blackColor]];
}
@end
