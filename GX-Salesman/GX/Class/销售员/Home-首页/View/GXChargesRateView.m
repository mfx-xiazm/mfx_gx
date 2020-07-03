//
//  GXChargesRateView.m
//  GX
//
//  Created by huaxin-01 on 2020/6/20.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXChargesRateView.h"
#import "GXGoodsDetail.h"

@interface GXChargesRateView ()
@property (weak, nonatomic) IBOutlet UIView *recommendRewardView;
@property (weak, nonatomic) IBOutlet UILabel *recommend_sale;
@property (weak, nonatomic) IBOutlet UILabel *recommend_provider;

@property (weak, nonatomic) IBOutlet UIView *platformRewardView;
@property (weak, nonatomic) IBOutlet UILabel *platform;
@property (weak, nonatomic) IBOutlet UILabel *provider;

@property (weak, nonatomic) IBOutlet UIView *saleManCommissionRewardView;
@property (weak, nonatomic) IBOutlet UILabel *rate1;
@property (weak, nonatomic) IBOutlet UILabel *rate2;
@property (weak, nonatomic) IBOutlet UILabel *rate3;

@end
@implementation GXChargesRateView

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)rateCloseClicked:(id)sender {
    if (self.rateCloseCall) {
        self.rateCloseCall();
    }
}
-(void)setRecommend:(GXRecommendReward *)recommend
{
    _recommend = recommend;
    self.platformRewardView.hidden = YES;
    self.saleManCommissionRewardView.hidden = YES;
    self.recommendRewardView.hidden = NO;

    self.recommend_sale.text = (_recommend.recommend_sale && _recommend.recommend_sale.length)?[NSString stringWithFormat:@"%@%%",_recommend.recommend_sale]:@"-";
    self.recommend_provider.text = (_recommend.recommend_provider && _recommend.recommend_provider.length)?[NSString stringWithFormat:@"%@%%",_recommend.recommend_provider]:@"-";
}
-(void)setCommission:(GXCommissionReward *)commission
{
    _commission = commission;
    
    if ([[MSUserManager sharedInstance].curUserInfo.post_id isEqualToString:@"1"]) {
        self.platformRewardView.hidden = NO;
        self.saleManCommissionRewardView.hidden = YES;
        self.recommendRewardView.hidden = YES;

        self.platform.text = [NSString stringWithFormat:@"%@%%",_commission.platform];
        self.provider.text = [NSString stringWithFormat:@"%@%%",_commission.provider];
    }else{
        self.platformRewardView.hidden = YES;
        self.saleManCommissionRewardView.hidden = NO;
        self.recommendRewardView.hidden = YES;
        
        self.rate3.text = [NSString stringWithFormat:@"%@%%",_commission.rate3];
        
        if ([[MSUserManager sharedInstance].curUserInfo.post_id isEqualToString:@"2"]) {
            self.rate1.text = [NSString stringWithFormat:@"%@%%",_commission.rate1];
            self.rate2.text = [NSString stringWithFormat:@"%@%%",_commission.rate2];
        }else if ([[MSUserManager sharedInstance].curUserInfo.post_id isEqualToString:@"3"]) {
            self.rate1.text = @"-";
            self.rate2.text = [NSString stringWithFormat:@"%@%%",_commission.rate2];
        }else{
            self.rate1.text = @"-";
            self.rate2.text = @"-";
        }
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self bezierPathByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
}
@end
