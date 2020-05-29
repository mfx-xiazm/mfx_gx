//
//  GXRegisterAddStoreFooter.m
//  GX
//
//  Created by 夏增明 on 2019/10/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXRegisterAddStoreFooter.h"

@implementation GXRegisterAddStoreFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)addClicked:(UIButton *)sender {
    if (self.addStoreCall) {
        self.addStoreCall();
    }
}

@end
