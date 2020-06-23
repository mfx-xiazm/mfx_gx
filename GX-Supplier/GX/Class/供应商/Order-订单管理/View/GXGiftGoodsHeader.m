//
//  GXGiftGoodsHeader.m
//  GX
//
//  Created by huaxin-01 on 2020/6/18.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXGiftGoodsHeader.h"
#import "GXGiftGoods.h"

@interface GXGiftGoodsHeader ()
@property (weak, nonatomic) IBOutlet UILabel *gift_order_no;
@property (weak, nonatomic) IBOutlet UILabel *gift_order_status;
@property (weak, nonatomic) IBOutlet UILabel *shop_name;

@end
@implementation GXGiftGoodsHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setGiftGoods:(GXGiftGoods *)giftGoods
{
    _giftGoods = giftGoods;
    self.gift_order_no.text = _giftGoods.provider_no;
    self.gift_order_status.text = _giftGoods.gift_order_status;
    self.shop_name.text = _giftGoods.shop_name;
}
@end
