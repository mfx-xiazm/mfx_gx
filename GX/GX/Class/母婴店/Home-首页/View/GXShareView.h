//
//  GXShareView.h
//  GX
//
//  Created by 夏增明 on 2019/11/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^shareTypeCall)(NSInteger index);
@interface GXShareView : UIView
/* 点击 */
@property(nonatomic,copy) shareTypeCall shareTypeCall;
@end

NS_ASSUME_NONNULL_END
