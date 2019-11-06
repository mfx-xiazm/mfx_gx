//
//  GXChooseClassFooter.m
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXChooseClassFooter.h"

@implementation GXChooseClassFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)numChangeClicked:(UIButton *)sender {
    if (sender.tag) {// +
        if ([self.buy_num.text integerValue] + 1 > self.stock_num) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"库存不足"];
            return;
        }
        self.buy_num.text = [NSString stringWithFormat:@"%zd",[self.buy_num.text integerValue] + 1];
    }else{// -
        if ([self.buy_num.text integerValue] - 1 < 1) {
            return;
        }
        self.buy_num.text = [NSString stringWithFormat:@"%zd",[self.buy_num.text integerValue] - 1];
    }
    if (self.buyNumCall) {
        self.buyNumCall([self.buy_num.text integerValue]);
    }
}
@end
