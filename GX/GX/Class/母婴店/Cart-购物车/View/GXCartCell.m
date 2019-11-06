//
//  GXCartCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXCartCell.h"
#import "GXCartData.h"

@interface GXCartCell ()
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *spec_value;
@property (weak, nonatomic) IBOutlet UILabel *cart_num;
@end
@implementation GXCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setGoods:(GXCartShopGoods *)goods
{
    _goods = goods;
    self.checkBtn.selected = _goods.is_checked;
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_goods.cover_img]];
    [self.goods_name setTextWithLineSpace:5.f withString:_goods.goods_name withFont:[UIFont systemFontOfSize:13]];
    
    self.price.text = [NSString stringWithFormat:@"￥%@",_goods.price];
    if (_goods.specs_attrs && _goods.specs_attrs.length) {
        self.spec_value.text = [NSString stringWithFormat:@"%@",_goods.specs_attrs];
    }else{
        self.spec_value.text = @"";
    }
    self.cart_num.text = _goods.cart_num;
}
- (IBAction)numChangeClicked:(UIButton *)sender {
    if (sender.tag) {// +
        if ([self.cart_num.text integerValue] + 1 > [_goods.stock integerValue]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"库存不足"];
            return;
        }
        self.cart_num.text = [NSString stringWithFormat:@"%zd",[self.cart_num.text integerValue] + 1];
    }else{// -
        if ([self.cart_num.text integerValue] - 1 < 1) {
            return;
        }
        self.cart_num.text = [NSString stringWithFormat:@"%zd",[self.cart_num.text integerValue] - 1];
    }
    _goods.cart_num = self.cart_num.text;
    if (self.cartHandleCall) {
        self.cartHandleCall(sender.tag);
    }
}
- (IBAction)checkClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    _goods.is_checked = sender.isSelected;
    if (self.cartHandleCall) {
        self.cartHandleCall(sender.tag);
    }
}
@end
