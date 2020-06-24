//
//  GXRenewMyOrderBigCellHeader.m
//  GX
//
//  Created by huaxin-01 on 2020/6/18.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXRenewMyOrderBigCellHeader.h"
#import "GXSalerOrder.h"

@interface GXRenewMyOrderBigCellHeader ()
@property (weak, nonatomic) IBOutlet UILabel *shop_name;

@end
@implementation GXRenewMyOrderBigCellHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setSalerOrder:(GXSalerOrder *)salerOrder
{
    _salerOrder = salerOrder;
    self.shop_name.text = _salerOrder.shop_name;
}
@end
