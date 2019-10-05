//
//  GXCartSectionHeader.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXCartSectionHeader.h"

@implementation GXCartSectionHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)cartClicked:(UIButton *)sender {
    if (self.cartHeaderClickedCall) {
        self.cartHeaderClickedCall(sender.tag);
    }
}

@end
