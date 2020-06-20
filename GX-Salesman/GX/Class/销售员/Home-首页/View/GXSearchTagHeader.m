//
//  GXSearchTagHeader.m
//  GX
//
//  Created by 夏增明 on 2019/12/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXSearchTagHeader.h"

@implementation GXSearchTagHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)cliearClicked:(UIButton *)sender {
    if (self.clearHistoryCall) {
        self.clearHistoryCall();
    }
}

@end
