//
//  GXSankPriceSectionFooter.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXSankPriceSectionFooter.h"
#import "GXSankPrice.h"

@interface GXSankPriceSectionFooter ()
@property (weak, nonatomic) IBOutlet UILabel *cart_num;
@property (weak, nonatomic) IBOutlet UILabel *price;
@end
@implementation GXSankPriceSectionFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setSank:(GXSankPrice *)sank
{
    _sank = sank;
    if (_sank.toatlPrice && _sank.toatlPrice.length) {
        [self.price setColorAttributedText:[NSString stringWithFormat:@"总计：￥%@",_sank.toatlPrice] andChangeStr:[NSString stringWithFormat:@"￥%@",_sank.toatlPrice] andColor:HXControlBg];
    }else{
        [self.price setColorAttributedText:[NSString stringWithFormat:@"总计：￥%@",_sank.price] andChangeStr:[NSString stringWithFormat:@"￥%@",_sank.price] andColor:HXControlBg];
    }
    self.cart_num.text = [NSString stringWithFormat:@"%ld",(long)_sank.buy_num];
}
- (IBAction)numChangeClicked:(UIButton *)sender {
    if (sender.tag) {// +
        if ([self.cart_num.text integerValue] + 1 > [_sank.stock integerValue]) {
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
    _sank.buy_num = [self.cart_num.text integerValue];
    _sank.toatlPrice = [NSString stringWithFormat:@"%.2f",_sank.buy_num * [_sank.price floatValue]];
    [self.price setColorAttributedText:[NSString stringWithFormat:@"总计：￥%@",_sank.toatlPrice] andChangeStr:[NSString stringWithFormat:@"￥%@",_sank.toatlPrice] andColor:HXControlBg];
}

- (IBAction)handleClickd:(UIButton *)sender {
    if (self.priceSankHandleCall) {
        self.priceSankHandleCall(sender.tag);
    }
}
@end
