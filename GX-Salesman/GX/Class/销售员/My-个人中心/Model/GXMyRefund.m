//
//  GXMyRefund.m
//  GX
//
//  Created by 夏增明 on 2019/11/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMyRefund.h"

@implementation GXMyRefund
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goods":[GYMyRefundGoods class],
             @"address":[GYMyRefundAddress class]
             };
}
@end

@implementation GYMyRefundGoods

@end

@implementation GYMyRefundAddress

@end
