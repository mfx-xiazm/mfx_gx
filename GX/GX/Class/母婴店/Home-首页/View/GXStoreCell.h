//
//  GXStoreCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXStore;
typedef void(^storeHandleCall)(NSInteger index);
@interface GXStoreCell : UITableViewCell
/* 点击 */
@property(nonatomic,copy) storeHandleCall storeHandleCall;
/* 店铺 */
@property(nonatomic,strong) GXStore *store;
@end

NS_ASSUME_NONNULL_END
