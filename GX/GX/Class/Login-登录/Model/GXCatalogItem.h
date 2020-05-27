//
//  GXCatalogItem.h
//  GX
//
//  Created by 夏增明 on 2019/10/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class GXBrandItem;
@interface GXCatalogItem : NSObject
@property (nonatomic, copy) NSString *catalog_id;
@property (nonatomic, copy) NSString *catalog_name;
@property (nonatomic, copy) NSString *catalog_img;
@property (nonatomic, copy) NSString *ordid;
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
/* 二级分类 */
@property(nonatomic,strong) NSArray<GXCatalogItem *> *catalog;
/* 二级品牌 */
@property(nonatomic,strong) NSArray<GXBrandItem *> *control;
/* 二级品牌 */
@property(nonatomic,strong) NSArray<GXBrandItem *> *brandData;
@end

@interface GXBrandItem : NSObject
@property (nonatomic, copy) NSString *brand_id;
@property (nonatomic, copy) NSString *brand_name;
@property (nonatomic, copy) NSString *brand_img;
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
