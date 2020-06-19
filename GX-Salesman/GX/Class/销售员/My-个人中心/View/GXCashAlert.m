//
//  GXCashAlert.m
//  GX
//
//  Created by huaxin-01 on 2020/5/27.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXCashAlert.h"

@implementation GXCashAlert

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (IBAction)kbowClicked:(UIButton *)sender {
    if (self.cashKnowCall) {
        self.cashKnowCall();
    }
}

@end
