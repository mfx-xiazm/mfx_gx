//
//  GXGiftGoodsDetailFooter.m
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXGiftGoodsDetailFooter.h"
#import "GXGiftGoods.h"
#import <zhPopupController.h>
#import "GXExpressShowView.h"

@interface GXGiftGoodsDetailFooter ()
@property (weak, nonatomic) IBOutlet UILabel *giftInfo;
@property (weak, nonatomic) IBOutlet UIButton *locitic_copy;
@property (nonatomic, strong) zhPopupController *alertPopVC;
@end
@implementation GXGiftGoodsDetailFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setGiftGoods:(GXGiftGoods *)giftGoods
{
    _giftGoods = giftGoods;
    if (_giftGoods.order_nos.count > 1) {
        [self.locitic_copy setTitle:@"  查看全部  " forState:UIControlStateNormal];
    }else{
        [self.locitic_copy setTitle:@"  复制  " forState:UIControlStateNormal];
    }
    [self.giftInfo setTextWithLineSpace:10.f withString:[NSString stringWithFormat:@"商品订单编号：%@\n赠品订单编号：%@\n下单时间：%@",_giftGoods.order_no,_giftGoods.gift_order_no,_giftGoods.create_time] withFont:[UIFont systemFontOfSize:13]];
}
- (IBAction)noCopyClicked:(UIButton *)sender {
    if (_giftGoods.order_nos.count > 1) {
        GXExpressShowView *show = [GXExpressShowView loadXibView];
        show.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 300.f);
        show.logistics_nos = _giftGoods.order_nos;
        hx_weakify(self);
        show.expressShowCloseClicked = ^{
            hx_strongify(weakSelf);
            [strongSelf.alertPopVC dismiss];
        };
        self.alertPopVC = [[zhPopupController alloc] initWithView:show size:show.bounds.size];
        self.alertPopVC.layoutType = zhPopupLayoutTypeBottom;
        [self.alertPopVC show];
    }else{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _giftGoods.order_no;
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"复制成功"];
    }
}

@end
