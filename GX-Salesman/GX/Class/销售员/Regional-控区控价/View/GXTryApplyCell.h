//
//  GXTryApplyCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXTryGoods;
typedef void(^getTryCall)(void);
@interface GXTryApplyCell : UITableViewCell
/* 商品 */
@property(nonatomic,strong) GXTryGoods *goods;
/* 点击 */
@property(nonatomic,copy) getTryCall getTryCall;
@end

NS_ASSUME_NONNULL_END
