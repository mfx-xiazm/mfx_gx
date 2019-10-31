//
//  GXBigCateCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXBigCateCell.h"
#import "GXCatalogItem.h"

@interface GXBigCateCell ()
@property (weak, nonatomic) IBOutlet UILabel *cateName;
@property (weak, nonatomic) IBOutlet UIView *line;
@end
@implementation GXBigCateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setLogItem:(GXCatalogItem *)logItem
{
    _logItem = logItem;
    self.cateName.text = _logItem.catalog_name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.cateName.backgroundColor = selected ? [UIColor whiteColor] : HXGlobalBg;
    self.cateName.textColor = selected ? HXControlBg : UIColorFromRGB(0x1A1A1A);
    //self.highlighted = selected;
    self.cateName.font = selected ?[UIFont boldSystemFontOfSize:14] : [UIFont systemFontOfSize:14];
    self.line.backgroundColor = selected ? HXControlBg : HXGlobalBg;
}

@end
