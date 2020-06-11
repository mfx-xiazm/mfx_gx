//
//  GXRebateView.m
//  GX
//
//  Created by huaxin-01 on 2020/6/11.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXRebateView.h"

@implementation GXRebateView

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self bezierPathByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
}
@end
