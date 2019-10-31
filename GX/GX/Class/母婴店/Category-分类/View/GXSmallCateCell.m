//
//  GXSmallCateCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXSmallCateCell.h"
#import "GXCatalogItem.h"

@interface GXSmallCateCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *item_title;

@end
@implementation GXSmallCateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCaItem:(GXCatalogItem *)caItem
{
    _caItem = caItem;
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_caItem.catalog_img]];
    self.item_title.text = _caItem.catalog_name;
}
-(void)setBrand:(GXBrandItem *)brand
{
    _brand = brand;
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_brand.brand_img]];
    self.item_title.text = _brand.brand_name;
}
@end
