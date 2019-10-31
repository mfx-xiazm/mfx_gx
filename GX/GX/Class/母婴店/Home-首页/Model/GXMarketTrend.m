//
//  GXMarketTrend.m
//  GX
//
//  Created by 夏增明 on 2019/10/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMarketTrend.h"

@implementation GXMarketTrend
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"series":[GXMarketTrendSeries class]};
}
@end

@implementation GXMarketTrendSeries
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goods":[GXSeriesGoods class]};
}
@end

@implementation GXSeriesGoods

@end
