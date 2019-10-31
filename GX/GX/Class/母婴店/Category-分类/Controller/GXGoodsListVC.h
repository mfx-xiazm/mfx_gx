//
//  GXGoodsListVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class GXCatalogItem,GXBrandItem;
@interface GXGoodsListVC : HXBaseViewController
/* 二级分类id */
@property(nonatomic,copy) NSString *catalog_id;
/* 品牌id */
@property(nonatomic,copy) NSString *brand_id;
/* 二级分类 */
@property(nonatomic,strong) NSArray<GXCatalogItem *> *catalogs;
/* 二级品牌 */
@property(nonatomic,strong) NSArray<GXBrandItem *> *brands;
@end

NS_ASSUME_NONNULL_END
