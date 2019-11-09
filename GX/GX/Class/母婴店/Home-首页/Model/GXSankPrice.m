//
//  GXSankPrice.m
//  GX
//
//  Created by 夏增明 on 2019/11/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXSankPrice.h"

@implementation GXSankPrice
-(NSInteger)buy_num
{
    if (_buy_num>0) {
        return _buy_num;
    }
    return 1;
}
@end
