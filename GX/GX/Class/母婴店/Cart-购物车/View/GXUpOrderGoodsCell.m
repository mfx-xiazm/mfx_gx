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

@interface GXUpOrderGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *goods_title;
@property (weak, nonatomic) IBOutlet UILabel *goods_spec;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *goods_num;
@property (weak, nonatomic) IBOutlet UILabel *refundStatus;

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
    self.goods_spec.text = (_goods.specs_attrs && _goods.specs_attrs.length)?[NSString stringWithFormat:@" %@ ",_goods.specs_attrs]:@"";
    self.goods_num.text = [NSString stringWithFormat:@"x%@",_goods.goods_num];
    
    if (_goods.refund_status && _goods.refund_status.length) {
        if ([_goods.refund_status isEqualToString:@"0"]) {
            self.refundStatus.hidden = YES;
        }else{
            if ([_goods.status isEqualToString:@"待评价"] || [_goods.status isEqualToString:@"已完成"]) {
                self.refundStatus.hidden = YES;
            }else{
                self.refundStatus.hidden = NO;
                if ([_goods.refund_status isEqualToString:@"1"]) {
                    self.refundStatus.text = @"退款中，等待供应商审核";
                }else if ([_goods.refund_status isEqualToString:@"2"]){
                    self.refundStatus.text = @"退款中，等待平台审核";
                }else if ([_goods.refund_status isEqualToString:@"3"]){
                    self.refundStatus.text = @"退款成功";
                }else if ([_goods.refund_status isEqualToString:@"4"]){
                    self.refundStatus.text = @"退款驳回";
                }else if ([_goods.refund_status isEqualToString:@"5"]){
                    self.refundStatus.text = @"供应商同意";
                }else{
                    self.refundStatus.text = @"供应商不同意";
                }
            }
        }
    }else{
        self.refundStatus.hidden = YES;
    }
}
-(void)setRefund:(GXMyRefund *)refund
{
    _refund = refund;
    
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_refund.cover_img]];
    [self.goods_title setTextWithLineSpace:5.f withString:(_refund.goods_name)?_refund.goods_name:@"" withFont:[UIFont systemFontOfSize:13]];
    self.price.text = [NSString stringWithFormat:@"￥%@",_refund.price];
    self.goods_spec.text = (_refund.specs_attrs&&_refund.specs_attrs.length)?[NSString stringWithFormat:@" %@ ",_refund.specs_attrs]:@"";
    self.goods_num.text = [NSString stringWithFormat:@"x%@",_refund.goods_num];
}
-(void)setRefundGoods:(GYMyRefundGoods *)refundGoods
{
    _refundGoods = refundGoods;
    
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_refundGoods.cover_img]];
    [self.goods_title setTextWithLineSpace:5.f withString:_refundGoods.goods_name?_refundGoods.goods_name:@"" withFont:[UIFont systemFontOfSize:13]];
    self.price.text = [NSString stringWithFormat:@"￥%@",_refundGoods.price];
    self.goods_spec.text = (_refundGoods.specs_attrs&&_refundGoods.specs_attrs.length)?[NSString stringWithFormat:@" %@ ",_refundGoods.specs_attrs]:@"";
    self.goods_num.text = [NSString stringWithFormat:@"x%@",_refundGoods.goods_num];
}
-(void)setUpGoods:(GXConfirmOrderGoods *)upGoods
{
    _upGoods = upGoods;
    
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_upGoods.cover_img]];
    [self.goods_title setTextWithLineSpace:5.f withString:_upGoods.goods_name?_upGoods.goods_name:@"" withFont:[UIFont systemFontOfSize:13]];
    self.price.text = [NSString stringWithFormat:@"￥%@",_upGoods.price];
    self.goods_spec.text = (_upGoods.specs_attrs&&_upGoods.specs_attrs.length)?[NSString stringWithFormat:@" %@ ",_upGoods.specs_attrs]:@"";
    self.goods_num.text = [NSString stringWithFormat:@"x%@",_upGoods.cart_num];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
