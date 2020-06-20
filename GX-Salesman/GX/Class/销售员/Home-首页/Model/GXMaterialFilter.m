//
//  GXMaterialFilter.m
//  GX
//
//  Created by 夏增明 on 2019/10/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMaterialFilter.h"
#import "GXTopSaleMaterial.h"
#import "GXCatalogItem.h"

@implementation GXMaterialFilter
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"plan":[GXTopSaleMaterial class],
             @"catalog":[GXCatalogItem class],
             @"advertise":[GXTopSaleMaterial class]
             };
}
@end
