//
//  FCDropMenuCollectionHeader.m
//  FC
//
//  Created by huaxin-01 on 2020/4/16.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCDropMenuCollectionHeader.h"

@implementation FCDropMenuCollectionHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addSubview:self.textLa];
        self.textLa.frame = CGRectMake(12, 0, frame.size.width*0.45, frame.size.height);
    }
    return self;
}
- (UILabel *)textLa{
    if (!_textLa) {
        _textLa = [UILabel new];
        _textLa.font = [UIFont systemFontOfSize:13.0f];
    }
    return _textLa;
}
@end
