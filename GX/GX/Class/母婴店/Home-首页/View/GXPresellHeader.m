//
//  GXPresellHeader.m
//  GX
//
//  Created by huaxin-01 on 2020/6/17.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXPresellHeader.h"

@interface GXPresellHeader ()
@property (weak, nonatomic) IBOutlet UIView *buttomVoew;

@end
@implementation GXPresellHeader

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.buttomVoew bezierPathByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(18, 18)];
}
@end
