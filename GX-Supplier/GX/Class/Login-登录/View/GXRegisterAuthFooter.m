//
//  GXRegisterAuthFooter.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXRegisterAuthFooter.h"

@implementation GXRegisterAuthFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)seletAgreeClicked:(UIButton *)sender {
    self.agreeBtn.selected = !self.agreeBtn.selected;
}
- (IBAction)agreeMentClicked:(UIButton *)sender {
    if (self.agreementCall) {
        self.agreementCall();
    }
}
- (IBAction)submitClicked:(UIButton *)sender {
    if (self.submitStoreCall) {
        self.submitStoreCall(sender);
    }
}



@end
