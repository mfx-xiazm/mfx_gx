//
//  GXPayTypeCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXPayTypeCell.h"
#import "GXPayType.h"

@interface GXPayTypeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *selectBtn;

@end
@implementation GXPayTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setPayType:(GXPayType *)payType
{
    _payType = payType;
    self.img.image = _payType.typeImg;
    self.name.text = _payType.typeName;
    self.selectBtn.image = _payType.isSelected?HXGetImage(@"协议选择"):HXGetImage(@"协议未选");
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
