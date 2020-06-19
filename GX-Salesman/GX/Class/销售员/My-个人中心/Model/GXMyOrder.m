//
//  GXMyOrder.m
//  GX
//
//  Created by 夏增明 on 2019/11/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMyOrder.h"

@implementation GXMyOrder
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goods":[GXMyOrderGoods class]
             };
}
@end

@implementation GXMyOrderGoods

@end
