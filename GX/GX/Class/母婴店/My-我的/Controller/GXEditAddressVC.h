//
//  GXEditAddressVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class GXMyAddress;
typedef void(^editSuccessCall)(void);
@interface GXEditAddressVC : HXBaseViewController
/* 地址 */
@property(nonatomic,strong) GXMyAddress *address;
/* 新增或者编辑成功 */
@property(nonatomic,copy) editSuccessCall editSuccessCall;
@end

NS_ASSUME_NONNULL_END
