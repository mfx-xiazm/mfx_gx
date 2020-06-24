//
//  GXExpressShowCell.m
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXExpressShowCell.h"

@implementation GXExpressShowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setLoc_no_str:(NSString *)loc_no_str
{
    _loc_no_str = loc_no_str;
    self.loc_no.text = [NSString stringWithFormat:@"快递单号：%@",_loc_no_str];
}
- (IBAction)locNoCopy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _loc_no_str;
    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"复制成功"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
