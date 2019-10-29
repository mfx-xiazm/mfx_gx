//
//  GXRegisterAuthCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXRegisterStore,HXBaseViewController;
typedef void(^cancelStoreCall)(void);
@interface GXRegisterAuthCell : UITableViewCell
/* 控制器 */
@property(nonatomic,weak) HXBaseViewController *target;
/* 店铺 */
@property(nonatomic,strong) GXRegisterStore *store;
/* 删除 */
@property(nonatomic,copy) cancelStoreCall cancelStoreCall;
@end

NS_ASSUME_NONNULL_END
