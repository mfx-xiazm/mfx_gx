//
//  RCTabBar.m
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTabBar.h"

@interface RCTabBar ()
/* 自定义大按钮 */
@property(nonatomic,strong) UIButton *plusBtn;
@end
@implementation RCTabBar

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setImage:[UIImage imageNamed:@"iocn_new_add"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"iocn_new_add"] forState:UIControlStateHighlighted];
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }
    return self;
}
-(void)plusClick {
    if ([self.rcDelegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.rcDelegate tabBarDidClickPlusButton:self];
    }
}
-(void)layoutSubviews {
    
    [super layoutSubviews];
    self.plusBtn.hxn_centerX = self.hxn_width *0.5;
    self.plusBtn.hxn_y = 0;
    CGFloat tabBarButtonW  = self.hxn_width / 5;
    self.plusBtn.hxn_width = tabBarButtonW;
    self.plusBtn.hxn_height = self.hxn_height;

    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            child.hxn_width = tabBarButtonW;
            child.hxn_x = tabbarButtonIndex *tabBarButtonW;
            tabbarButtonIndex ++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex ++;
            }
        }
    }
}
@end
