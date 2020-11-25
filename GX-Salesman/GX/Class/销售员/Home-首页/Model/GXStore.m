//
//  GXStore.m
//  GX
//
//  Created by 夏增明 on 2019/10/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXStore.h"
#import "GXCatalogItem.h"

@implementation GXStore
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goods":[GXStoreGoods class],
             @"coupons":[GXStoreCoupons class],
             @"coupon":[GXStoreCoupons class],
             @"catalog":[GXCatalogItem class],
             @"provider_customer":[GXStoreCustomer class]
             };
}
@end

@implementation GXStoreGoods

@end

@implementation GXStoreCoupons

@end

@implementation GXStoreCustomer

@end
