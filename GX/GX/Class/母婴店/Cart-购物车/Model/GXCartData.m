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
    return @{@"goodsData":[GXCartShopGoods class]
             };
}
@end

@implementation GXCartShopGoods

@end
