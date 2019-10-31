//
//  GXMarketTrendCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXSeriesGoods;
typedef void(^trendBtnCall)(NSInteger index);
@interface GXMarketTrendCell : UITableViewCell
/* 系列 */
@property(nonatomic,strong) GXSeriesGoods *goods;
/* 点击 */
@property(nonatomic,copy) trendBtnCall trendBtnCall;
@end

NS_ASSUME_NONNULL_END
