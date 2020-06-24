//
//  GXRenewMyOrderBigCellHeader.h
//  GX
//
//  Created by huaxin-01 on 2020/6/18.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMyOrderProvider,GXMyRefund;
@interface GXRenewMyOrderBigCellHeader : UIView
@property (nonatomic, strong) GXMyOrderProvider *provider;
@property (nonatomic, strong) GXMyRefund *refund;
@end

NS_ASSUME_NONNULL_END
