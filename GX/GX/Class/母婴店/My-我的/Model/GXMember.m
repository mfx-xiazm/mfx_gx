//
//  GXMember.m
//  GX
//
//  Created by 夏增明 on 2019/11/1.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMember.h"

@implementation GXMember
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"level":[GXMemberLevel class]};
}
@end

@implementation GXMemberLevel

@end
