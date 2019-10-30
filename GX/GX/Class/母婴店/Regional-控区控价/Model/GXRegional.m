//
//  GXRegional.m
//  GX
//
//  Created by 夏增明 on 2019/10/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXRegional.h"


@implementation GXRegional
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"adv":[GXRegionalBanner class],
             @"notice":[GXRegionalNotice class],
             @"week_newer":[GXRegionalWeekNewer class],
             @"try_cover":[GXRegionalTry class]
             };
}
@end

@implementation GXRegionalBanner

@end

@implementation GXRegionalNotice

@end

@implementation GXRegionalWeekNewer

@end

@implementation GXRegionalTry

@end
