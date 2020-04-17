//
//  GXGoodsDetailHeader.h
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GXGoodsDetail;
typedef void(^countDownCall)(void);
typedef void(^bannerClickedCall)(NSInteger index);
@interface GXGoodsDetailHeader : UIView
/* 商品详情 */
@property(nonatomic,strong) GXGoodsDetail *goodsDetail;
@property (weak, nonatomic) IBOutlet UIView *rushView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rushViewHeight;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeViewHeight;
/* 倒是结束 */
@property(nonatomic,copy) countDownCall countDownCall;
@property (nonatomic, copy) bannerClickedCall bannerClickedCall;
@end

NS_ASSUME_NONNULL_END
