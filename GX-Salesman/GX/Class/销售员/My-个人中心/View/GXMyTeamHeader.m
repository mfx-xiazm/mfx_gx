//
//  GXMyTeamHeader.m
//  GX
//
//  Created by huaxin-01 on 2020/6/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXMyTeamHeader.h"

@interface GXMyTeamHeader ()
@property (weak, nonatomic) IBOutlet UIView *buttomView;
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
}
-(void)layoutSubviews
{
    [super layoutSubviews];

    [self.buttomView bezierPathByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
}

@end
