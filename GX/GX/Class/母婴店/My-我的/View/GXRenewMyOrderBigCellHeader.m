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

@interface GXRenewMyOrderBigCellHeader ()
@property (weak, nonatomic) IBOutlet UILabel *shop_name;

@end
@implementation GXRenewMyOrderBigCellHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setProvider:(GXMyOrderProvider *)provider
{
    _provider = provider;
    self.shop_name.text = _provider.shop_name;
}
-(void)setRefund:(GXMyRefund *)refund
{
    _refund = refund;
    self.shop_name.text = _refund.shop_name;
}
@end
