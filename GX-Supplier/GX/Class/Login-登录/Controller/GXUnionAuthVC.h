//
//  GXUnionAuthVC.h
//  GX
//
//  Created by huaxin-01 on 2020/8/6.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXUnionAuthVC : HXBaseViewController
/* 用户id */
@property(nonatomic,copy) NSString *uid;
/* token */
@property(nonatomic,copy) NSString *token;

@property (nonatomic, copy) NSString *ums_reg_id;

@property (nonatomic, copy) NSString *company_account;
@end

NS_ASSUME_NONNULL_END
