//
//  GXActivityCataInfo.m
//  GX
//
//  Created by 夏增明 on 2019/10/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXActivityCataInfo.h"
#import "GXCatalogItem.h"

@implementation GXActivityCataInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"adv":[GXActivityBanner class],
             @"catalog":[GXCatalogItem class]
             };
}
@end

@implementation GXActivityBanner

@end
