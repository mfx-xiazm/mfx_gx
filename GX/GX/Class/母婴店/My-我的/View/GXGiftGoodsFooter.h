//
//  GXGiftGoodsFooter.h
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^giftClickedCall)(NSInteger index);
@interface GXGiftGoodsFooter : UIView
@property (weak, nonatomic) IBOutlet UIView *handleView;
@property (nonatomic, copy) giftClickedCall giftClickedCall;
@end

NS_ASSUME_NONNULL_END
