//
//  GXMyTeamHeader.m
//  GX
//
//  Created by huaxin-01 on 2020/6/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXMyTeamHeader.h"
#import "GXMyTeamCount.h"

@interface GXMyTeamHeader ()
@property (weak, nonatomic) IBOutlet UIView *buttomView;

@property (weak, nonatomic) IBOutlet UIView *countView;
@property (nonatomic, weak) IBOutlet UILabel *p_count;
@property (nonatomic, weak) IBOutlet UILabel *c_count;
@property (nonatomic, weak) IBOutlet UILabel *d_count;

@property (weak, nonatomic) IBOutlet UIView *countView1;
@property (nonatomic, weak) IBOutlet UILabel *c_count1;
@property (nonatomic, weak) IBOutlet UILabel *d_count1;

@property (weak, nonatomic) IBOutlet UIView *countView2;
@property (nonatomic, weak) IBOutlet UILabel *d_count2;

@end
@implementation GXMyTeamHeader

-(void)awakeFromNib{
    [super awakeFromNib];
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = HXGetImage(@"我的团队背景");
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.frame = self.bounds;
    [self insertSubview:self.imageView atIndex:0];
    self.imageViewFrame = self.imageView.frame;
    
    if ([[MSUserManager sharedInstance].curUserInfo.post_id isEqualToString:@"1"]) {
        self.countView.hidden = NO;
        self.countView1.hidden = YES;
        self.countView2.hidden = YES;
    }else if ([[MSUserManager sharedInstance].curUserInfo.post_id isEqualToString:@"2"]) {
        self.countView.hidden = YES;
        self.countView1.hidden = NO;
        self.countView2.hidden = YES;
    }else{
        self.countView.hidden = YES;
        self.countView1.hidden = YES;
        self.countView2.hidden = NO;
    }
}
-(void)setTeamCount:(GXMyTeamCount *)teamCount
{
    _teamCount = teamCount;
    if ([[MSUserManager sharedInstance].curUserInfo.post_id isEqualToString:@"1"]) {
        self.countView.hidden = NO;
        self.countView1.hidden = YES;
        self.countView2.hidden = YES;
        
        self.p_count.text = _teamCount.p_count;
        self.c_count.text = _teamCount.c_count;
        self.d_count.text = _teamCount.d_count;
    }else if ([[MSUserManager sharedInstance].curUserInfo.post_id isEqualToString:@"2"]) {
        self.countView.hidden = YES;
        self.countView1.hidden = NO;
        self.countView2.hidden = YES;
        
        self.c_count1.text = _teamCount.c_count;
        self.d_count1.text = _teamCount.d_count;
    }else{
        self.countView.hidden = YES;
        self.countView1.hidden = YES;
        self.countView2.hidden = NO;
    
        self.d_count2.text = _teamCount.d_count;
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];

    [self.buttomView bezierPathByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
}

@end
