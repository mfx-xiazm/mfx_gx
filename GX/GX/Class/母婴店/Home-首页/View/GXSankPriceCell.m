//
//  GXSankPriceCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXSankPriceCell.h"
#import "GXSankPrice.h"

@interface GXSankPriceCell ()
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *stoke;
@property (weak, nonatomic) IBOutlet UILabel *seac;
@property (weak, nonatomic) IBOutlet UIButton *expand;

@end
@implementation GXSankPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setSank:(GXSankPrice *)sank
{
    _sank = sank;
    
    [self.price setColorAttributedText:[NSString stringWithFormat:@"折合单价：￥%@",_sank.reducedPrice] andChangeStr:[NSString stringWithFormat:@"￥%@",_sank.reducedPrice] andColor:HXControlBg];;
    self.stoke.text = [NSString stringWithFormat:@"库存：%@",_sank.stock];
    self.seac.text = _sank.specs_attrs;
    
    [self.expand setImage:_sank.isExpand?HXGetImage(@"已展开"):HXGetImage(@"展开") forState:UIControlStateNormal];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
