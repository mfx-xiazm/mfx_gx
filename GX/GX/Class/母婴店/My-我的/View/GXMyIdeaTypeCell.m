//
//  GXMyIdeaTypeCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMyIdeaTypeCell.h"
#import "GXSuggestionType.h"

@interface GXMyIdeaTypeCell ()
@property (weak, nonatomic) IBOutlet UILabel *type_name;

@end
@implementation GXMyIdeaTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setType:(GXSuggestionType *)type
{
    _type = type;
    
    self.type_name.text = _type.suggestion_type;
    
    self.type_name.textColor = _type.isSelected?[UIColor whiteColor]:UIColorFromRGB(0x666666);
    self.type_name.backgroundColor = _type.isSelected?HXControlBg:UIColorFromRGB(0xF3F3F3);
}
@end
