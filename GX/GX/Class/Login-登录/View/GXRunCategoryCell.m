//
//  GXRunCategoryCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXRunCategoryCell.h"
#import "GXCatalogItem.h"

@interface GXRunCategoryCell ()

@end
@implementation GXRunCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCaItem:(GXCatalogItem *)caItem
{
    _caItem = caItem;
    self.contentText.text = _caItem.catalog_name;
    if (_caItem.isSelected) {
        self.contentText.layer.borderColor = HXControlBg.CGColor;
        self.contentText.backgroundColor = HXControlBg;
        self.contentText.textColor = [UIColor whiteColor];
    }else{
        self.contentText.layer.borderColor = [UIColor blackColor].CGColor;
        self.contentText.backgroundColor = [UIColor whiteColor];
        self.contentText.textColor = [UIColor blackColor];
    }
}
@end
