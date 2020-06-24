//
//  GXMyTeamCell.m
//  GX
//
//  Created by huaxin-01 on 2020/6/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXMyTeamCell.h"
#import "GXMyTeam.h"

@interface GXMyTeamCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UILabel *post_name;
@end
@implementation GXMyTeamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setTeam:(GXMyTeam *)team
{
    _team = team;
    self.name.text = [NSString stringWithFormat:@"%@ %@",_team.username,_team.phone];
    self.total.text = _team.total;
    self.post_name.text = _team.post_name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
