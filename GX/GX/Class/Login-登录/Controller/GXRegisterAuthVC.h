//
//  GXRegisterAuthVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXRegisterAuthVC : HXBaseViewController
@property(nonatomic,copy) NSString *username;
@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *pwd;
@property(nonatomic,copy) NSString *inviteCode;

@end

NS_ASSUME_NONNULL_END
