//
//  GXMarketTrendSectionHeader.h
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GXMarketTrendSeries;
@interface GXMarketTrendSectionHeader : UIView
/* 系列 */
@property(nonatomic,strong) GXMarketTrendSeries *series;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

NS_ASSUME_NONNULL_END
