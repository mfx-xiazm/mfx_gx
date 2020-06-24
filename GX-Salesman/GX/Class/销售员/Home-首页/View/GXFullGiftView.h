//
//  GXFullGiftView.h
//  GX
//
//  Created by huaxin-01 on 2020/6/11.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXGoodsGiftRule;
typedef void(^closeClickedCall)(void);
@interface GXFullGiftView : UIView
@property(nonatomic,strong) NSArray<GXGoodsGiftRule *> *gift_rule;
@property (nonatomic, copy) closeClickedCall closeClickedCall;
@end

NS_ASSUME_NONNULL_END
