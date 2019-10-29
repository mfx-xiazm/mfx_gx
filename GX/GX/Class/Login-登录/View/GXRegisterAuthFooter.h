//
//  GXRegisterAuthFooter.h
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^agreementCall)(void);
typedef void(^submitStoreCall)(UIButton *btn);
@interface GXRegisterAuthFooter : UIView
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
/* 协议 */
@property(nonatomic,copy) agreementCall agreementCall;
/* 提交 */
@property(nonatomic,copy) submitStoreCall submitStoreCall;
@end

NS_ASSUME_NONNULL_END
