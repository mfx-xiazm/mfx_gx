//
//  FCTextField.m
//  FC
//
//  Created by huaxin-01 on 2020/5/13.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCTextField.h"

#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface FCTextField ()<UITextFieldDelegate>

@end
@implementation FCTextField

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.delegate = self;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.kLimitType == 1) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHA] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }else if (self.kLimitType == 2) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }else if (self.kLimitType == 3){
        //新输入的
         if (string.length == 0) {
             return YES;
         }

        //第一个参数，被替换字符串的range
        //第二个参数，即将键入或者粘贴的string
        //返回的是改变过后的新str，即textfield的新的文本内容
         NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
         
        if (checkStr.length > 0) {
            if ([checkStr doubleValue] == 0) {
              //判断首位不能为零
                return NO;
            }
        }
         //正则表达式（只支持两位小数）
         NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
        //判断新的文本内容是否符合要求
         return [self isValid:checkStr withRegex:regex];
    }else {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
}
//检测改变过的文本是否匹配正则表达式，如果匹配表示可以键入，否则不能键入
- (BOOL) isValid:(NSString*)checkStr withRegex:(NSString*)regex
{
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}
@end
