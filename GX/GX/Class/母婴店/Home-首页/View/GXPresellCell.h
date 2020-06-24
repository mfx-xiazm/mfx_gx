//
//  GXPresellCell.h
//  GX
//
//  Created by huaxin-01 on 2020/6/17.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXPreSales;
@interface GXPresellCell : UITableViewCell
@property (nonatomic, strong) GXPreSales *preSale;
/// 倒计时到0时回调
@property (nonatomic, copy) void(^countDownZero)(GXPreSales *);
@end

NS_ASSUME_NONNULL_END
