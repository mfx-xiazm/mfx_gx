//
//  GXChooseClassFooter.m
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXChooseClassFooter.h"

@interface GXChooseClassFooter ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *limit_txt;

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
    if (self.limit_num != -1 && self.limit_num != 0) {//限购
        if ([textField.text integerValue] > self.limit_num) {
            textField.text = [NSString stringWithFormat:@"%ld",(long)self.limit_num];
        }
    }
    if ([textField.text integerValue] > self.stock_num) {
        textField.text = [NSString stringWithFormat:@"%ld",(long)self.stock_num];
    }
    if (self.buyNumCall) {
        self.buyNumCall([self.buy_num.text integerValue]);
    }
}
-(void)setLimit_num:(NSInteger)limit_num
{
    _limit_num = limit_num;
    
    if (_limit_num != -1 && _limit_num != 0) {//限购
        self.limit_txt.text = [NSString stringWithFormat:@"此规格限购%zd份",_limit_num];
    }else{
        self.limit_txt.text = @"";
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
        if (self.limit_num != -1 && self.limit_num != 0) {//限购
            if ([self.buy_num.text integerValue] + 1 > self.limit_num) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[NSString stringWithFormat:@"限购%zd份",self.limit_num]];
                return;
            }
        }
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
