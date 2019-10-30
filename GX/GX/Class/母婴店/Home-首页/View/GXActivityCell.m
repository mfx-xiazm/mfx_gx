//
//  GXActivityCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXActivityCell.h"
#import "GXActivity.h"

@interface GXActivityCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *acti_title;

@end
@implementation GXActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setActivity:(GXActivity *)activity
{
    _activity = activity;
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_activity.cover_img]];
    [self.acti_title setTextWithLineSpace:5. withString:_activity.material_title withFont:[UIFont systemFontOfSize:13]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
