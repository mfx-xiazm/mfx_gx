//
//  GXGiftGoodsDetailFooter.m
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXGiftGoodsDetailFooter.h"
#import "GXGiftGoods.h"

@interface GXGiftGoodsDetailFooter ()
@property (weak, nonatomic) IBOutlet UILabel *giftInfo;
@end
@implementation GXGiftGoodsDetailFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setGiftGoods:(GXGiftGoods *)giftGoods
{
    _giftGoods = giftGoods;
    [self.giftInfo setTextWithLineSpace:10.f withString:[NSString stringWithFormat:@"订单编号：%@\n下单时间：%@",_giftGoods.gift_order_no,_giftGoods.create_time] withFont:[UIFont systemFontOfSize:13]];
}
- (IBAction)noCopyClicked:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _giftGoods.gift_order_no;
    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"复制成功"];
}

@end
