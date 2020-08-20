//
//  GXRegisterAuthHeader.h
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXRegisterStore,GXSelectRegion,HXBaseViewController;
typedef void(^storeTypeCall)(void);
@interface GXRegisterAuthHeader : UIView
/* 控制器 */
@property(nonatomic,strong) HXBaseViewController *target;
/* 单击 */
@property(nonatomic,copy) storeTypeCall storeTypeCall;
/* 经营类目 */
@property(nonatomic,strong) NSArray *catalogItem;
/* 主门店 */
@property(nonatomic,strong) GXRegisterStore *mainStore;
@end

NS_ASSUME_NONNULL_END
