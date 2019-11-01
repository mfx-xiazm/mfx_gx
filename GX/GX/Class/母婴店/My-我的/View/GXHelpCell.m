//
//  GXHelpCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXHelpCell.h"
#import "GXHelp.h"

@interface GXHelpCell ()
@property (weak, nonatomic) IBOutlet UILabel *help_title;

@end
@implementation GXHelpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setHelp:(GXHelp *)help
{
    _help = help;
    [self.help_title setTextWithLineSpace:5.f withString:_help.help_title withFont:[UIFont systemFontOfSize:14]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
