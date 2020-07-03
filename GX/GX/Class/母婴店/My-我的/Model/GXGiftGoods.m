//
//  GXGiftGoods.m
//  GX
//
//  Created by huaxin-01 on 2020/6/22.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXGiftGoods.h"

@implementation GXGiftGoods
-(void)setOrder_no:(NSString *)order_no
{
   if (order_no.length) {
       _order_nos = [order_no componentsSeparatedByString:@","];
       _order_no = _order_nos.firstObject;
   }else{
       _order_no = @"";
   }
}
@end
