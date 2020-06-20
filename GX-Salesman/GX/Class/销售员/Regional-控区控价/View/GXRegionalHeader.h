//
//  GXRegionalHeader.h
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXRegional;
typedef void(^regionalClickedCall)(NSInteger type,NSInteger index);
@interface GXRegionalHeader : UIView
/* 点击 */
@property(nonatomic,copy) regionalClickedCall regionalClickedCall;
/* 控区控价 */
@property(nonatomic,strong) GXRegional *regional;
@end

NS_ASSUME_NONNULL_END
