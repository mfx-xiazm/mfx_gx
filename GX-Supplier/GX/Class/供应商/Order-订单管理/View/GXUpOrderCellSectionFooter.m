//
//  GXUpOrderCellSectionFooter.m
//  GX
//
//  Created by huaxin-01 on 2020/6/15.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXUpOrderCellSectionFooter.h"
#import "GXMyOrder.h"
#import "GXMyRefund.h"

@interface GXUpOrderCellSectionFooter ()
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *totalFreight;
@property (weak, nonatomic) IBOutlet UILabel *rebate;
@property (weak, nonatomic) IBOutlet UILabel *rebateTxt;
@property (weak, nonatomic) IBOutlet UILabel *order_desc;

@end
@implementation GXUpOrderCellSectionFooter
-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setOrderDetail:(GXMyOrder *)orderDetail
{
    _orderDetail = orderDetail;
    self.totalPrice.text = [NSString stringWithFormat:@"%@",_orderDetail.order_price_amount];
    self.totalFreight.text = [NSString stringWithFormat:@"%@",_orderDetail.order_freight_amount];
    
    if (_orderDetail.order_brand_rebate && _orderDetail.order_brand_rebate.length) {
        self.rebateTxt.text = [NSString stringWithFormat:@"返利%@%%",_orderDetail.order_brand_rebate];
        self.rebate.text = [NSString stringWithFormat:@"-%@",_orderDetail.order_brand_amount];
    }else{
        self.rebateTxt.text = @"";
        self.rebate.text = @"0.00";
    }
    GXMyOrderGoods *goods = _orderDetail.goods.firstObject;
    if (goods.order_goods_desc && goods.order_goods_desc.length) {
        self.order_desc.text = goods.order_goods_desc;
    }else{
        self.order_desc.text = @"无";
    }
}
-(void)setRefundDetail:(GXMyRefund *)refundDetail
{
    _refundDetail = refundDetail;
    
    self.totalPrice.text = [NSString stringWithFormat:@"%@",_refundDetail.order_price_amount];
    self.totalFreight.text = [NSString stringWithFormat:@"%@",_refundDetail.order_freight_amount];
    
    if (_refundDetail.order_brand_rebate && _refundDetail.order_brand_rebate.length) {
        self.rebateTxt.text = [NSString stringWithFormat:@"返利%@%%",_refundDetail.order_brand_rebate];
        self.rebate.text = [NSString stringWithFormat:@"-%@",_refundDetail.order_brand_amount];
    }else{
        self.rebateTxt.text = @"";
        self.rebate.text = @"0.00";
    }
    GYMyRefundGoods *goods = _refundDetail.goods.firstObject;
    if (goods.order_goods_desc && goods.order_goods_desc.length) {
        self.order_desc.text = goods.order_goods_desc;
    }else{
        self.order_desc.text = @"无";
    }
}
@end
