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
             @"provider":[GXMyRefundProvider class],
             @"address":[GYMyRefundAddress class],
             @"goods_recommend":[GXMyRefundRecommend class]
    };
}

-(void)setLogistics_no:(NSString *)logistics_no
{
    if (logistics_no.length) {
        _logistics_nos = [logistics_no componentsSeparatedByString:@","];
        _logistics_no = _logistics_nos.firstObject;
    }else{
        _logistics_no = @"";
    }
}
@end

@implementation GXMyRefundProvider
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"goods":[GYMyRefundGoods class]
    };
}
@end

@implementation GYMyRefundGoods

@end

@implementation GYMyRefundAddress

@end


@implementation GXMyRefundRecommend

@end
