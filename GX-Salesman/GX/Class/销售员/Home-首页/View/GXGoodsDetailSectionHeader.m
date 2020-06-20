//
//  GXGoodsDetailSectionHeader.m
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXGoodsDetailSectionHeader.h"

@implementation GXGoodsDetailSectionHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)moreClicked:(UIButton *)sender {
    if (self.sectionClickCall) {
        self.sectionClickCall();
    }
}

@end
