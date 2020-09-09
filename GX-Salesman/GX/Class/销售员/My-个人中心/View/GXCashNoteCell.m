//
//  GXCashNoteCell.m
//  GX
//
//  Created by huaxin-01 on 2020/6/18.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXCashNoteCell.h"
#import "GXCashNote.h"

@interface GXCashNoteCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleTxt;
@property (weak, nonatomic) IBOutlet UILabel *apply_amount;
@property (weak, nonatomic) IBOutlet UILabel *approve_time;
@property (weak, nonatomic) IBOutlet UILabel *apply_status;

@end
@implementation GXCashNoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setNote:(GXCashNote *)note
{
    _note = note;
    self.titleTxt.text = [NSString stringWithFormat:@"余额提现-到%@(%@)",_note.bank_name,(_note.card_no.length>4)?[_note.card_no substringFromIndex:_note.card_no.length-4]:_note.card_no];
    self.approve_time.text = _note.create_time;
    
    if ([_note.apply_status isEqualToString:@"1"] || [_note.apply_status isEqualToString:@"4"]) {
        self.apply_amount.text = [NSString stringWithFormat:@"-￥%@",_note.apply_amount];
        self.apply_status.text = @"提现中";
    }else if ([_note.apply_status isEqualToString:@"2"] || [_note.apply_status isEqualToString:@"5"]) {
        self.apply_amount.text = [NSString stringWithFormat:@"-￥%@",_note.apply_amount];
        self.apply_status.text = @"提现成功";
    }else{
        self.apply_status.text = @"提现失败";
        self.apply_amount.text = [NSString stringWithFormat:@"+￥%@",_note.apply_amount];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
