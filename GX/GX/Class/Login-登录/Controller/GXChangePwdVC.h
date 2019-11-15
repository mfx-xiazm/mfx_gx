//
//  GXChangePwdVC.h
//  GX
//
//  Created by 夏增明 on 2019/9/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXChangePwdVC : HXBaseViewController
/* 手机号 */
@property(nonatomic,copy) NSString *phoneStr;
/* 1忘记密码  2修改密码 */
@property(nonatomic,assign) NSInteger dataType;
@end

NS_ASSUME_NONNULL_END
