//
//  GXRenewCartSectionHeader.m
//  GX
//
//  Created by huaxin-01 on 2020/6/15.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXRenewCartSectionHeader.h"
#import "GXCartData.h"
#import <zhPopupController.h>
#import "GXFullGiftView.h"
#import "GXRebateView.h"

@interface GXRenewCartSectionHeader ()
@property (strong, nonatomic) IBOutlet UILabel *dazengLabel;
@property (strong, nonatomic) IBOutlet UILabel *fanliLabel;

@property (strong, nonatomic) IBOutlet UILabel *doubledazengLabel;
@property (strong, nonatomic) IBOutlet UILabel *doubleFanliLabel;

/* 分享弹框 */
@property (nonatomic, strong) zhPopupController *sharePopVC;
@end
@implementation GXRenewCartSectionHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setGiftData:(NSArray<GXCartGoodsGift *> *)giftData
{
    _giftData = giftData;
    NSMutableString *contentTxt = [NSMutableString string];
    for (GXCartGoodsGift *gift  in _giftData) {
        if ([gift.gift_type isEqualToString:@"1"]) {// 本品
            if (contentTxt.length) {
                [contentTxt appendFormat:@"，%@",[NSString stringWithFormat:@"买%@赠%@",gift.begin_num,gift.gift_num]];
            }else{
                [contentTxt appendFormat:@"%@",[NSString stringWithFormat:@"买%@赠%@",gift.begin_num,gift.gift_num]];
            }
        }else{// 其他
            if (contentTxt.length) {
                [contentTxt appendFormat:@"，%@",[NSString stringWithFormat:@"买%@搭赠%@%@个",gift.begin_num,gift.goods_name,gift.gift_num]];
            }else{
                [contentTxt appendFormat:@"%@",[NSString stringWithFormat:@"买%@搭赠%@%@个",gift.begin_num,gift.goods_name,gift.gift_num]];
            }
        }
    }
    self.dazengLabel.text = contentTxt;
    self.doubledazengLabel.text = contentTxt;
}
-(void)setRebate:(NSArray<GXCartGoodsRebate *> *)rebate
{
    _rebate = rebate;
    NSMutableString *rebateStr = [NSMutableString string];
    for (GXCartGoodsRebate *rebateObj in _rebate) {
        if (rebateStr.length) {
            [rebateStr appendFormat:@"，%@",[NSString stringWithFormat:@"满%@元返%@%%",rebateObj.begin_price,rebateObj.percent]];
        }else{
            [rebateStr appendFormat:@"%@",[NSString stringWithFormat:@"满%@元返%@%%",rebateObj.begin_price,rebateObj.percent]];
        }
    }
    self.fanliLabel.text = rebateStr;
    self.doubleFanliLabel.text = rebateStr;
}
- (IBAction)giftBtnClicked:(UIButton *)sender {
    hx_weakify(self);
    if (sender.tag == 1) {
        GXFullGiftView *giftView = [GXFullGiftView loadXibView];
        giftView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 300.f);
        giftView.cart_gift_rule = self.giftData;
        giftView.closeClickedCall = ^{
            hx_strongify(weakSelf);
            [strongSelf.sharePopVC dismiss];
        };
        self.sharePopVC = [[zhPopupController alloc] initWithView:giftView size:giftView.bounds.size];
        self.sharePopVC.layoutType = zhPopupLayoutTypeBottom;
        [self.sharePopVC show];
       
    }else{
        GXRebateView *rebateView = [GXRebateView loadXibView];
        rebateView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 400.f);
        rebateView.cart_rebate = self.rebate;
        rebateView.closeClickedCall = ^{
            hx_strongify(weakSelf);
            [strongSelf.sharePopVC dismiss];
        };
        self.sharePopVC = [[zhPopupController alloc] initWithView:rebateView size:rebateView.bounds.size];
        self.sharePopVC.layoutType = zhPopupLayoutTypeBottom;
        [self.sharePopVC show];
    }
}

@end
