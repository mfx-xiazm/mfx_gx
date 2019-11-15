//
//  GXUpOrderGoodsCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXUpOrderGoodsCell.h"
#import "GXMyOrder.h"
#import "GXMyRefund.h"
#import "GXConfirmOrder.h"
#import "GXSalerOrder.h"

@interface GXUpOrderGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *goods_title;
@property (weak, nonatomic) IBOutlet UILabel *goods_spec;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *goods_num;
@end
@implementation GXUpOrderGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setGoods:(GXMyOrderGoods *)goods
{
    _goods = goods;
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_goods.cover_img]];
    [self.goods_title setTextWithLineSpace:5.f withString:(_goods.goods_name)?_goods.goods_name:@"" withFont:[UIFont systemFontOfSize:13]];
    self.price.text = [NSString stringWithFormat:@"￥%@",_goods.price];
    self.goods_spec.text = (_goods.specs_attrs && _goods.specs_attrs.length)?[NSString stringWithFormat:@"%@",_goods.specs_attrs]:@"";
    self.goods_num.text = [NSString stringWithFormat:@"x%@",_goods.goods_num];
}
-(void)setRefund:(GXMyRefund *)refund
{
    _refund = refund;
    
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_refund.cover_img]];
    [self.goods_title setTextWithLineSpace:5.f withString:(_refund.goods_name)?_refund.goods_name:@"" withFont:[UIFont systemFontOfSize:13]];
    self.price.text = [NSString stringWithFormat:@"￥%@",_refund.price];
    self.goods_spec.text = (_refund.specs_attrs&&_refund.specs_attrs.length)?[NSString stringWithFormat:@"%@",_refund.specs_attrs]:@"";
    self.goods_num.text = [NSString stringWithFormat:@"x%@",_refund.goods_num];
}
-(void)setRefundGoods:(GYMyRefundGoods *)refundGoods
{
    _refundGoods = refundGoods;
    
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_refundGoods.cover_img]];
    [self.goods_title setTextWithLineSpace:5.f withString:_refundGoods.goods_name?_refundGoods.goods_name:@"" withFont:[UIFont systemFontOfSize:13]];
    self.price.text = [NSString stringWithFormat:@"￥%@",_refundGoods.price];
    self.goods_spec.text = (_refundGoods.specs_attrs&&_refundGoods.specs_attrs.length)?[NSString stringWithFormat:@"%@",_refundGoods.specs_attrs]:@"";
    self.goods_num.text = [NSString stringWithFormat:@"x%@",_refundGoods.goods_num];
}
-(void)setUpGoods:(GXConfirmOrderGoods *)upGoods
{
    _upGoods = upGoods;
    
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_upGoods.cover_img]];
    [self.goods_title setTextWithLineSpace:5.f withString:_upGoods.goods_name?_upGoods.goods_name:@"" withFont:[UIFont systemFontOfSize:13]];
    self.price.text = [NSString stringWithFormat:@"￥%@",_upGoods.price];
    self.goods_spec.text = (_upGoods.specs_attrs&&_upGoods.specs_attrs.length)?[NSString stringWithFormat:@" %@",_upGoods.specs_attrs]:@"";
    self.goods_num.text = [NSString stringWithFormat:@"x%@",_upGoods.cart_num];
}

-(void)setSalerOrder:(GXSalerOrder *)salerOrder
{
    _salerOrder = salerOrder;
    
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_salerOrder.cover_img]];
    [self.goods_title setTextWithLineSpace:5.f withString:_salerOrder.goods_name?_salerOrder.goods_name:@"" withFont:[UIFont systemFontOfSize:13]];
    self.price.text = [NSString stringWithFormat:@"￥%@",_salerOrder.price];
    self.goods_spec.text = (_salerOrder.specs_attrs&&_salerOrder.specs_attrs.length)?[NSString stringWithFormat:@" %@",_salerOrder.specs_attrs]:@"";
    self.goods_num.text = [NSString stringWithFormat:@"x%@",_salerOrder.goods_num];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
