//
//  GXRunCategoryCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXRunCategoryCell.h"
#import "GXCatalogItem.h"
#import "GXTopSaleMaterial.h"
#import "GXGoodsDetail.h"

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
-(void)setLogItem:(GXCatalogItem *)logItem
{
    _logItem = logItem;
    self.contentText.text = _logItem.catalog_name;
    if (_logItem.isSelected) {
        self.contentText.layer.borderColor = HXControlBg.CGColor;
        self.contentText.backgroundColor = HXControlBg;
        self.contentText.textColor = [UIColor whiteColor];
    }else{
        self.contentText.layer.borderColor = UIColorFromRGB(0xf3f3f3).CGColor;
        self.contentText.backgroundColor = UIColorFromRGB(0xf3f3f3);
        self.contentText.textColor = [UIColor blackColor];
    }
}
-(void)setMaterial:(GXTopSaleMaterial *)material
{
    _material = material;

    self.contentText.text = _material.material_filter_name;
    if (_material.isSelected) {
        self.contentText.layer.borderColor = HXControlBg.CGColor;
        self.contentText.backgroundColor = HXControlBg;
        self.contentText.textColor = [UIColor whiteColor];
    }else{
        self.contentText.layer.borderColor = UIColorFromRGB(0xf3f3f3).CGColor;
        self.contentText.backgroundColor = UIColorFromRGB(0xf3f3f3);
        self.contentText.textColor = [UIColor blackColor];
    }
}
-(void)setBrandItem:(GXBrandItem *)brandItem
{
    _brandItem = brandItem;
    self.contentText.text = _brandItem.brand_name;
    if (_brandItem.isSelected) {
        self.contentText.layer.borderColor = HXControlBg.CGColor;
        self.contentText.backgroundColor = HXControlBg;
        self.contentText.textColor = [UIColor whiteColor];
    }else{
        self.contentText.layer.borderColor = UIColorFromRGB(0xf3f3f3).CGColor;
        self.contentText.backgroundColor = UIColorFromRGB(0xf3f3f3);
        self.contentText.textColor = [UIColor blackColor];
    }
}

-(void)setSubSpec:(GXGoodsDetailSubSpec *)subSpec
{
    _subSpec = subSpec;
    
    self.contentText.text = _subSpec.attr_name;
    self.contentText.layer.cornerRadius = 15.f;
}
-(void)setLogisticst:(GXGoodsLogisticst *)logisticst
{
    _logisticst = logisticst;
    
    self.contentText.text = _logisticst.freight_type;
    
    if (_logisticst.isSelected) {
        self.contentText.textColor = [UIColor whiteColor];
        self.contentText.backgroundColor = HXControlBg;
        self.contentText.layer.borderColor = [UIColor clearColor].CGColor;
    }else{
        self.contentText.textColor = [UIColor blackColor];
        self.contentText.backgroundColor = [UIColor whiteColor];
        self.contentText.layer.borderColor = [UIColor blackColor].CGColor;
    }
}
@end
