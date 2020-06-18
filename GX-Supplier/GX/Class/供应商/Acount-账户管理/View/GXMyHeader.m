//
//  GXMyHeader.m
//  GX
//
//  Created by huaxin-01 on 2020/6/18.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXMyHeader.h"

@interface GXMyHeader ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *buttomView;

@end
@implementation GXMyHeader

-(void)awakeFromNib{
    [super awakeFromNib];
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = HXGetImage(@"个人中心背景");
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.frame = self.bounds;
    [self.contentView insertSubview:self.imageView atIndex:0];
    self.imageViewFrame = self.imageView.frame;
}
-(void)layoutSubviews
{
    [super layoutSubviews];

    [self.buttomView bezierPathByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
}

- (IBAction)btnClicked:(UIButton *)sender {
    if (self.headerBtnClicked) {
        self.headerBtnClicked(sender.tag);
    }
}
@end
