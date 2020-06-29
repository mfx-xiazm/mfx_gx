//
//  GXRebateView.m
//  GX
//
//  Created by huaxin-01 on 2020/6/11.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXRebateView.h"
#import "GXGoodsDetail.h"

@interface GXRebateView ()
@property (weak, nonatomic) IBOutlet UILabel *rebateTxt;

@end

@implementation GXRebateView

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setRebate:(NSArray<GXGoodsRebate *> *)rebate
{
    _rebate = rebate;
    NSMutableString *rebateStr = [NSMutableString string];
    for (GXGoodsRebate *rebateObj in _rebate) {
        if (rebateStr.length) {
            [rebateStr appendFormat:@"，%@",[NSString stringWithFormat:@"满%@元返%@%%",rebateObj.begin_price,rebateObj.percent]];
        }else{
            [rebateStr appendFormat:@"%@",[NSString stringWithFormat:@"满%@元返%@%%",rebateObj.begin_price,rebateObj.percent]];
        }
    }

    if (rebateStr.length) {
        [self.rebateTxt setTextWithLineSpace:10 withString:rebateStr withFont:[UIFont systemFontOfSize:13]];
    }else{
        self.rebateTxt.text = @"无";
    }
}
- (IBAction)closeClicked:(UIButton *)sender {
    if (self.closeClickedCall) {
        self.closeClickedCall();
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self bezierPathByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
}
@end
