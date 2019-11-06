//
//  GXConfirmOrder.m
//  GX
//
//  Created by 夏增明 on 2019/11/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXConfirmOrder.h"
#import "GXMyAddress.h"
#import "GXMyCoupon.h"

@implementation GXConfirmOrder
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"defaultAddress":[GXMyAddress class],
             @"goodsData":[GXConfirmOrderData class]};
}
+ (NSDictionary *)modelCustomPropertyMapper
{
      return @{@"goodsData":@"goodsData.goodsDetail"};
}
@end

@implementation GXConfirmOrderData

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goods":[GXConfirmOrderGoods class],
             @"shopCouponData":[GXMyCoupon class]};
}

@end

@implementation GXConfirmOrderGoods

@end

