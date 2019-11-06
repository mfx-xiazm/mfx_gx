//
//  GXMyBusiness.m
//  GX
//
//  Created by 夏增明 on 2019/11/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMyBusiness.h"

@implementation GXMyBusiness
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"brand":[GXMyBrandBusiness class],
             @"catalog":[GXMyCataBusiness class]
             };
}
@end

@implementation GXMyBrandBusiness

@end

@implementation GXMyCataBusiness

@end
