//
//  GXSpecBtn.m
//  GX
//
//  Created by huaxin-01 on 2020/8/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXSpecBtn.h"

@implementation GXSpecBtn

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setImage:HXGetImage(@"spec_bg") forState:UIControlStateNormal];
        self.layer.cornerRadius = 2.f;
        self.layer.borderColor = HXControlBg.CGColor;
        self.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.hxn_x = self.hxn_width - 15.f;
    self.imageView.hxn_y = self.hxn_height - 15.f;
    
    self.titleLabel.hxn_x = 15.f;
}

@end
