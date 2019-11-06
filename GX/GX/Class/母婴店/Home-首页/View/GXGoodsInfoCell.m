//
//  GXGoodsInfoCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXGoodsInfoCell.h"
#import "GXGoodsDetail.h"

@interface GXGoodsInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *param_name;
@property (weak, nonatomic) IBOutlet UILabel *param_value;

@end
@implementation GXGoodsInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setParam:(GXGoodsDetailParam *)param
{
    _param = param;
    self.param_name.text = _param.param_name;
    self.param_value.text = _param.param_desc;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
