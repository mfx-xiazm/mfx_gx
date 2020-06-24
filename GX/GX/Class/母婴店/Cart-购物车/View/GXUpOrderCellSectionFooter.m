//
//  GXUpOrderCellSectionFooter.m
//  GX
//
//  Created by huaxin-01 on 2020/6/15.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXUpOrderCellSectionFooter.h"
#import "GXConfirmOrder.h"

@interface GXUpOrderCellSectionFooter ()
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *totalFreight;
@end
@implementation GXUpOrderCellSectionFooter
-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setOrderData:(GXConfirmOrderData *)orderData
{
    _orderData = orderData;

    self.totalPrice.text = [NSString stringWithFormat:@"￥%.2f",[_orderData.shopActTotalPrice floatValue]];
    self.totalFreight.text = [NSString stringWithFormat:@"￥%@",_orderData.shopActTotalFreight];

}
@end
