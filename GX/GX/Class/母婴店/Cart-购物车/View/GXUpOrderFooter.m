//
//  GXUpOrderFooter.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXUpOrderFooter.h"

@implementation GXUpOrderFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)couponClicked:(UIButton *)sender {
    if (self.getCouponCall) {
        self.getCouponCall();
    }
}

@end
