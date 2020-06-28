//
//  GXChargesRateView.h
//  GX
//
//  Created by huaxin-01 on 2020/6/20.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXRecommendReward,GXCommissionReward;
typedef void(^rateCloseCall)(void);
@interface GXChargesRateView : UIView
@property (weak, nonatomic) IBOutlet UILabel *rate_title;
@property (nonatomic, copy) rateCloseCall rateCloseCall;
@property(nonatomic,strong) GXRecommendReward *recommend;
@property(nonatomic,strong) GXCommissionReward *commission;
@end

NS_ASSUME_NONNULL_END
