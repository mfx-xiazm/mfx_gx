//
//  GXChangeBindVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^changeSuccessCall)(NSString *phone);
@interface GXChangeBindVC : HXBaseViewController
/* 旧手机号 */
@property(nonatomic,copy) NSString *phoneStr;
/* 成功 */
@property(nonatomic,copy) changeSuccessCall changeSuccessCall;
@end

NS_ASSUME_NONNULL_END
