//
//  GXRegisterAddStoreFooter.h
//  GX
//
//  Created by 夏增明 on 2019/10/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^addStoreCall)(void);
@interface GXRegisterAddStoreFooter : UIView
/* 点击 */
@property(nonatomic,copy) addStoreCall addStoreCall;
@end

NS_ASSUME_NONNULL_END
