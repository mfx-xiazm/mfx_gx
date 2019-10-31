//
//  GXRunCategoryCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXCatalogItem,GXTopSaleMaterial;
@interface GXRunCategoryCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentText;
/* 类目 */
@property(nonatomic,strong) GXCatalogItem *caItem;
/* 类目 */
@property(nonatomic,strong) GXCatalogItem *logItem;
/* 素材 */
@property(nonatomic,strong) GXTopSaleMaterial *material;
@end

NS_ASSUME_NONNULL_END
