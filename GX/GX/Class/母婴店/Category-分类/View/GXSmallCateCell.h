//
//  GXSmallCateCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXCatalogItem,GXBrandItem;
@interface GXSmallCateCell : UICollectionViewCell
/* 二级分类 */
@property(nonatomic,strong) GXCatalogItem *caItem;
/* 二级品牌 */
@property(nonatomic,strong) GXBrandItem *brand;
@end

NS_ASSUME_NONNULL_END
