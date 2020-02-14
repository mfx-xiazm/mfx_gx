//
//  GXAuthStep3VC.h
//  GX
//
//  Created by 夏增明 on 2020/2/14.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXAuthStep3VC : HXBaseViewController
/* 用户id */
@property(nonatomic,copy) NSString *uid;
/* token */
@property(nonatomic,copy) NSString *token;
@end

NS_ASSUME_NONNULL_END
