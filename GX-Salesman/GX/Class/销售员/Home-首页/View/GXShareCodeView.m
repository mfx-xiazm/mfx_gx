//
//  GXShareCodeView.m
//  GX
//
//  Created by 夏增明 on 2019/11/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXShareCodeView.h"

@implementation GXShareCodeView

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (IBAction)shareClicked:(UIButton *)sender {
    if (self.shareTypeCall) {
        self.shareTypeCall(sender.tag);
    }
}

@end
