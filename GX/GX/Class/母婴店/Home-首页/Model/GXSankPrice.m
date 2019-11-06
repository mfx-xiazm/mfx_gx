//
//  GXSankPrice.m
//  GX
//
//  Created by 夏增明 on 2019/11/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXSankPrice.h"

@implementation GXSankPrice
-(NSString *)sale_num
{
    if ([_sale_num isEqualToString:@"0"] || !_sale_num.length) {
        return @"1";
    }
    return _sale_num;
}
@end
