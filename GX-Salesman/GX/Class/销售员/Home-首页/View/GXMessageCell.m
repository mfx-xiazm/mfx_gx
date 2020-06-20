//
//  GXMessageCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMessageCell.h"
#import "GXMessage.h"

@interface GXMessageCell ()
@property (weak, nonatomic) IBOutlet UIView *msgState;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *desc;

@end
@implementation GXMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setMsg:(GXMessage *)msg
{
    _msg = msg;
    if ([_msg.isRead isEqualToString:@"1"]) {
        self.msgState.hidden = YES;
    }else{
        self.msgState.hidden = NO;
    }
    self.title.text = _msg.msg_title;
    self.desc.text = _msg.msg_content;
    self.time.text = _msg.create_time;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
