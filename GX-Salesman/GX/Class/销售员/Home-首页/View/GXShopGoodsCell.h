//
//  GXShopGoodsCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GYHomePushGoods,GXSearchResult,GXStoreGoods,GXBrandGoods;
@interface GXShopGoodsCell : UICollectionViewCell
/* 商品 */
@property(nonatomic,strong) GYHomePushGoods *goods;
/* h商品 */
@property(nonatomic,strong) GXSearchResult *search;
/* 商品 */
@property(nonatomic,strong) GXStoreGoods *storeGoods;
/* 商品 */
@property(nonatomic,strong) GXBrandGoods *brandGoods;
@end

NS_ASSUME_NONNULL_END
