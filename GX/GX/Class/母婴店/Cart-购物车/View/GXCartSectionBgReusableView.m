//
//  GXCartSectionBgReusableView.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXCartSectionBgReusableView.h"

@interface GXCartSectionBgReusableView ()
@property(nonatomic,strong)UIImageView* imgV;
@end

@implementation GXCartSectionBgReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imgV = [[UIImageView alloc] init];
        self.imgV.backgroundColor = [UIColor whiteColor];
        self.imgV.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.imgV];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imgV.frame = CGRectMake(10, 0, self.bounds.size.width-20.f, self.bounds.size.height-10.f);
    [self.imgV setShadowWithCornerRadius:5.f shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.1 shadowRadius:5.f];
}
@end
