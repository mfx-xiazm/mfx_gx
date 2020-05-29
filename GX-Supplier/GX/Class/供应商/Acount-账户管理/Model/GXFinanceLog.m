//
//  GXFinanceLog.m
//  GX
//
//  Created by 夏增明 on 2019/11/8.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXFinanceLog.h"

@implementation GXFinanceLog
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"orderInfo":[GXLogOrder class]};
}
@end

@implementation GXLogOrder

@end
