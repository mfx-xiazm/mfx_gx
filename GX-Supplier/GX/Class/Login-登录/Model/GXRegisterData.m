//
//  GXRegisterData.m
//  GX
//
//  Created by 夏增明 on 2019/11/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXRegisterData.h"
#import "GXCatalogItem.h"

@implementation GXRegisterData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"catalog":[GXCatalogItem class],
             @"account":[GXPlatAccount class],
             @"provider_type":[GXProviderType class]};
}
@end

@implementation GXPlatAccount

@end

@implementation GXProviderType

@end
