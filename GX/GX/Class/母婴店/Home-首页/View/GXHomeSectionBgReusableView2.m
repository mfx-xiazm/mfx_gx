//
//  GXHomeSectionBgReusableView2.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXHomeSectionBgReusableView2.h"

@interface GXHomeSectionBgReusableView2()
@property(nonatomic,strong)UIImageView* imgV;
/* 底部背景 */
@property(nonatomic,strong) UIView *buttomBgV;
@end

@implementation GXHomeSectionBgReusableView2
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imgV = [[UIImageView alloc] init];
        self.imgV.backgroundColor = UIColorFromRGB(0xEA4A5C);
        self.imgV.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.imgV];
        
        self.buttomBgV = [[UIView alloc] init];
        self.buttomBgV.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.buttomBgV];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imgV.frame = CGRectMake(10.f, 5.f, self.bounds.size.width-20.f, self.bounds.size.height - 10.f);
    [self.imgV setShadowWithCornerRadius:5.f shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.1 shadowRadius:5.f];
    
    CGFloat bgHeight = (self.bounds.size.width-40.f)/4.0+40.f;
    self.buttomBgV.frame = CGRectMake(20.f, self.bounds.size.height-10.f-bgHeight, self.bounds.size.width-40.f, bgHeight);
}
@end
