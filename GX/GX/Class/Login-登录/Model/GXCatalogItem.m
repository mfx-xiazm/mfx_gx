//
//  GXCatalogItem.m
//  GX
//
//  Created by 夏增明 on 2019/10/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXCatalogItem.h"

@implementation GXCatalogItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"catalog":[GXCatalogItem class],
             @"control":[GXBrandItem class]
             };
}
@end

@implementation GXBrandItem

@end
