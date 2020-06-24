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
#import "GXSalerOrder.h"

@interface GXMyOrderHeader ()
@property (weak, nonatomic) IBOutlet UILabel *shop_name;
@end
@implementation GXMyOrderHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setOrder:(GXMyOrder *)order
{
    _order = order;
    self.shop_name.text = _order.shop_name;
}
-(void)setRefund:(GXMyRefund *)refund
{
    _refund = refund;
     self.shop_name.text = _refund.shop_name;
}
-(void)setSalerOrder:(GXSalerOrder *)salerOrder
{
    _salerOrder = salerOrder;
    self.shop_name.text = _salerOrder.shop_name;
}
@end
