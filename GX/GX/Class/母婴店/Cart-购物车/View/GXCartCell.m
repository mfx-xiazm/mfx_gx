//
//  GXCartCell.m
//  GX
//
//  Created by huaxin-01 on 2020/6/15.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXCartCell.h"
#import "GXCartData.h"

@interface GXCartCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *spec_value;
@property (weak, nonatomic) IBOutlet UITextField *cart_num;
@end

@implementation GXCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cart_num.delegate = self;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField hasText] || [textField.text integerValue] == 0) {
        textField.text = @"1";
    }
    if ([textField.text integerValue] > [_goods.stock integerValue]) {
        textField.text = [NSString stringWithFormat:@"%ld",(long)[_goods.stock integerValue]];
    }
    
    _goods.cart_num = textField.text;
    if (self.cartHandleCall) {
        self.cartHandleCall(0);//0或1均可以，代表商品数量变化
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
           NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
