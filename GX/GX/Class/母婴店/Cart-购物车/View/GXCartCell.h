//
//  GXCartCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXCartShopGoods;
typedef void(^cartHandleCall)(NSInteger index);
@interface GXCartCell : UICollectionViewCell
/* 商品 */
@property(nonatomic,strong) GXCartShopGoods *goods;
/* 点击 */
@property(nonatomic,copy) cartHandleCall cartHandleCall;
@end

NS_ASSUME_NONNULL_END
