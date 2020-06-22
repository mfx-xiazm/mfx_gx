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
    return @{@"goods":[GXMyOrderGoods class],
             @"goods_recommend":[GXMyOrderRecommend class]
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

@implementation GXMyOrderGoods

@end

@implementation GXMyOrderRecommend

@end
