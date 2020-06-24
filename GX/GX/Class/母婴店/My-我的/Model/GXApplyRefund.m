//
//  GXApplyRefund.m
//  GX
//
//  Created by huaxin-01 on 2020/6/24.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXApplyRefund.h"

@implementation GXApplyRefund
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"orderReason":[GXApplyRefundReason class]
             };
}

@end

@implementation GXApplyRefundReason

@end
