//
//  GXRenewCartCell.h
//  GX
//
//  Created by huaxin-01 on 2020/6/15.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXCartData;
typedef void(^renewCartHeaderClickedCall)(NSInteger index);
typedef void(^renewCartNumHandleCall)(NSInteger index);
typedef void(^renewCartDelCall)(NSString *cart_id);
@interface GXRenewCartCell : UITableViewCell
/* 商品 */
@property(nonatomic,strong) GXCartData *cartData;
@property (nonatomic, copy) renewCartHeaderClickedCall renewCartHeaderClickedCall;
@property (nonatomic, copy) renewCartNumHandleCall renewCartNumHandleCall;
@property (nonatomic, copy) renewCartDelCall renewCartDelCall;
@end

NS_ASSUME_NONNULL_END
