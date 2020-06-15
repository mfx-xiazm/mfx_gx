//
//  GXRenewCartHeader.h
//  GX
//
//  Created by huaxin-01 on 2020/6/15.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GXCartData;
typedef void(^cartHeaderClickedCall)(NSInteger index);
@interface GXRenewCartHeader : UIView
/* 点击事件 */
@property(nonatomic,copy) cartHeaderClickedCall cartHeaderClickedCall;
/* 商品 */
@property(nonatomic,strong) GXCartData *cartData;
@end

NS_ASSUME_NONNULL_END
