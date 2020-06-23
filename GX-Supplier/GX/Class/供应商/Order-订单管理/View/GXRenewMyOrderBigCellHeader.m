//
//  GXRenewMyOrderBigCellHeader.m
//  GX
//
//  Created by huaxin-01 on 2020/6/18.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXRenewMyOrderBigCellHeader.h"
#import "GXMyOrder.h"
#import "GXMyRefund.h"

@interface GXRenewMyOrderBigCellHeader()
@property (weak, nonatomic) IBOutlet UILabel *shop_name;

@end
@implementation GXRenewMyOrderBigCellHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setMyOrder:(GXMyOrder *)myOrder
{
    _myOrder = myOrder;
    self.shop_name.text = _myOrder.shop_name;
}
-(void)setMyRefund:(GXMyRefund *)myRefund
{
    _myRefund = myRefund;
    self.shop_name.text = _myRefund.shop_name;
}
@end
