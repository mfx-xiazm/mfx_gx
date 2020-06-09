//
//  GXCashVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^cashCall)(void);
@interface GXCashVC : HXBaseViewController
/* 可提现金额 */
@property(nonatomic,copy) NSString *cashable;
@property (nonatomic, copy) cashCall cashCall;
@end

NS_ASSUME_NONNULL_END
