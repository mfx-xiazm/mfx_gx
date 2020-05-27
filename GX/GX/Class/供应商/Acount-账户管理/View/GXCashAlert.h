//
//  GXCashAlert.h
//  GX
//
//  Created by huaxin-01 on 2020/5/27.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^cashKnowCall)(void);
@interface GXCashAlert : UIView
@property (nonatomic, copy) cashKnowCall cashKnowCall;
@end

NS_ASSUME_NONNULL_END
