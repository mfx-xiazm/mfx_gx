//
//  GXMyOrderHeader.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMyOrderHeader.h"
#import "GXMyOrder.h"
#import "GXMyRefund.h"
#import "GXGiftGoods.h"

@interface GXMyOrderHeader ()
@property (weak, nonatomic) IBOutlet UILabel *shop_name;
@end
@implementation GXMyOrderHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setOrderProvider:(GXMyOrderProvider *)orderProvider
{
    _orderProvider = orderProvider;
    self.shop_name.text = _orderProvider.shop_name;
}
-(void)setRefundProvider:(GXMyRefundProvider *)refundProvider
{
    _refundProvider = refundProvider;
    self.shop_name.text = _refundProvider.shop_name;
}
-(void)setGiftGoods:(GXGiftGoods *)giftGoods
{
    _giftGoods = giftGoods;
    self.shop_name.text = _giftGoods.shop_name;
}
@end
