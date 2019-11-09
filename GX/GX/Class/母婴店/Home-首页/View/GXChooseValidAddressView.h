//
//  GXChooseValidAddressView.h
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMyAddress;
typedef void(^chooseAddressCall)(GXMyAddress * _Nullable address);
@interface GXChooseValidAddressView : UIView
/* 地址列表 */
@property(nonatomic,strong) NSArray *addressList;
/* 选中 */
@property(nonatomic,copy) chooseAddressCall chooseAddressCall;
@end

NS_ASSUME_NONNULL_END
