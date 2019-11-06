//
//  GXMyAddressVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class GXMyAddress;
typedef void(^getAddressCall)(GXMyAddress *address);
@interface GXMyAddressVC : HXBaseViewController
/* 选择 */
@property(nonatomic,copy) getAddressCall getAddressCall;
@end

NS_ASSUME_NONNULL_END
