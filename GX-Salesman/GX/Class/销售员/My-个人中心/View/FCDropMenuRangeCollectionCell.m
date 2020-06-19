//
//  FCDropMenuRangeCollectionCell.m
//  FC
//
//  Created by huaxin-01 on 2020/4/16.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCDropMenuRangeCollectionCell.h"
#import "WSDatePickerView.h"

@interface FCDropMenuRangeCollectionCell()<UITextFieldDelegate>

@end
@implementation FCDropMenuRangeCollectionCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self.contentView addSubview:self.lowText];
        self.lowText.layer.masksToBounds = YES;
        [self.contentView addSubview:self.highText];
        self.highText.layer.masksToBounds = YES;
        [self.contentView addSubview:self.lineLa];
        self.highText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        self.lowText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        self.lowText.delegate = self;
        self.lowText.font = [UIFont systemFontOfSize:13.0];
        self.highText.font = [UIFont systemFontOfSize:13.0];
        self.highText.delegate = self;
        self.highText.textAlignment = NSTextAlignmentCenter;
        self.lowText.textAlignment = NSTextAlignmentCenter;
        self.lowText.keyboardType = UIKeyboardTypeDecimalPad;
        self.highText.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return self;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.isShowPicker) {
        NSDate *scrollToDate = nil;
        if (textField == self.lowText) {
            if ([textField hasText]) {
                scrollToDate = [NSDate date:textField.text WithFormat:@"yyyy-MM-dd"];
            }else{
                if ([self.highText hasText]) {
                    scrollToDate = [NSDate date:self.highText.text WithFormat:@"yyyy-MM-dd"];
                }else{
                    scrollToDate = [NSDate date];
                }
            }
        }else{
           if ([textField hasText]) {
               scrollToDate = [NSDate date:textField.text WithFormat:@"yyyy-MM-dd"];
           }else{
               if ([self.lowText hasText]) {
                   scrollToDate = [NSDate date:self.lowText.text WithFormat:@"yyyy-MM-dd"];
               }else{
                   scrollToDate = [NSDate date];
               }
           }
        }
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            
            NSTimeZone *nowTimeZone = [NSTimeZone localTimeZone];
            NSInteger timeOffset = [nowTimeZone secondsFromGMTForDate:selectDate];
            NSDate *newDate = [selectDate dateByAddingTimeInterval:timeOffset];
            
            NSString *date = [newDate stringWithFormat:@"yyyy-MM-dd"];
            textField.text = date;
            self.fieldBlock(textField,date);
        }];
        datepicker.doneButtonColor = HXControlBg;
        datepicker.dateLabelColor = HXControlBg;
        if (textField == self.lowText) {
            if ([self.highText hasText]) {
                datepicker.maxLimitDate = [NSDate date:self.highText.text WithFormat:@"yyyy-MM-dd"];
            }else{
                datepicker.maxLimitDate = [NSDate date];
            }
        }else{
            if ([self.lowText hasText]) {
                datepicker.minLimitDate = [NSDate date:self.lowText.text WithFormat:@"yyyy-MM-dd"];
            }else{
                datepicker.maxLimitDate = [NSDate date];
            }
        }
        
        [datepicker show];
        return NO;
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *mainText = @"";
    if ([string isEqual:@""]) {
        if (![textField.text isEqualToString:@""]) {
            mainText = [textField.text substringToIndex:[textField.text length] - 1];
        }else{
            mainText = textField.text;
        }
    }else{
        mainText = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    
    self.fieldBlock(textField,mainText);
    return YES;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.lowText.frame = CGRectMake(0, 0, self.frame.size.width*0.45, self.frame.size.height);
    self.lowText.layer.cornerRadius = self.frame.size.height/2.0;
    self.lineLa.frame = CGRectMake(0, 0, self.frame.size.width*0.1, self.frame.size.height);
    self.lineLa.center = self.contentView.center;
    self.highText.frame = CGRectMake(self.frame.size.width*0.55, 0, self.frame.size.width*0.45, self.frame.size.height);
    self.highText.layer.cornerRadius = self.frame.size.height/2.0;
}
- (UITextField *)lowText{
    if (!_lowText) {
        _lowText = [UITextField new];
        _lowText.leftViewMode = UITextFieldViewModeAlways;
    }
    return _lowText;
}
- (UITextField *)highText{
    if (!_highText) {
        _highText = [UITextField new];
        _highText.leftViewMode = UITextFieldViewModeAlways;
    }
    return _highText;
}
- (UILabel *)lineLa{
    if (!_lineLa) {
        _lineLa = [UILabel new];
        _lineLa.textAlignment = NSTextAlignmentCenter;
        _lineLa.text = @"-";
    }
    return _lineLa;
}

@end
