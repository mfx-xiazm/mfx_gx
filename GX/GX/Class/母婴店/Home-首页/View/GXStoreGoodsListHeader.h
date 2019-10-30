//
//  GXStoreGoodsListHeader.h
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GXStore;
typedef void(^storeMsgCall)(void);
@interface GXStoreGoodsListHeader : UIView
/** 店铺基本信息 */
@property(nonatomic,strong) GXStore *storeInfo;
/* 信息点击 */
@property(nonatomic,copy) storeMsgCall storeMsgCall;
@end

NS_ASSUME_NONNULL_END
