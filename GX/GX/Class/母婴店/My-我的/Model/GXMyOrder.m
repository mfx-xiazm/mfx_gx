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
    return @{ @"provider":[GXMyOrderProvider class],
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

@implementation GXMyOrderProvider
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"goods":[GXMyOrderGoods class],
             @"brand_rebate":[GXMyOrderRebate class]
             
             };
}
@end

@implementation GXMyOrderRebate
// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if (dic[@"order_brand_rebate"]) {
        _rebate_percent = [NSString stringWithFormat:@"%@",dic[@"order_brand_rebate"]];
    }
    if (dic[@"order_brand_amount"]) {
        _goods_rebate_amount = [NSString stringWithFormat:@"%@",dic[@"order_brand_amount"]];
    }
    return YES;
}
@end

@implementation GXMyOrderGoods

@end

@implementation GXMyOrderRecommend

@end
