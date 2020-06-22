//
//  GXCartData.m
//  GX
//
//  Created by 夏增明 on 2019/11/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXCartData.h"

@implementation GXCartData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"sale_data":[GXCartSaleData class]
             };
}
@end

@implementation GXCartSaleData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"goodsData":[GXCartShopGoods class],
             @"giftData":[GXCartGoodsGift class],
             @"rebate":[GXCartGoodsRebate class]
             };
}
@end

@implementation GXCartGoodsGift

@end

@implementation GXCartGoodsRebate

@end

@implementation GXCartShopGoods

@end
