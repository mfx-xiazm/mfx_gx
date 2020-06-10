//
//  GXChooseClassFooter.m
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXChooseClassFooter.h"

@interface GXChooseClassFooter ()<UITextFieldDelegate>

@end
@implementation GXChooseClassFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    self.buy_num.delegate = self;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField hasText] || [textField.text integerValue] == 0) {
        textField.text = @"1";
    }
    if ([textField.text integerValue] > self.stock_num) {
        textField.text = [NSString stringWithFormat:@"%ld",(long)self.stock_num];
    }
    if (self.buyNumCall) {
        self.buyNumCall([self.buy_num.text integerValue]);
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
           NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
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
