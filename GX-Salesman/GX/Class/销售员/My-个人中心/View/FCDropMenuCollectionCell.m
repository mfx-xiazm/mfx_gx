//
//  FCDropMenuCollectionCell.m
//  FC
//
//  Created by huaxin-01 on 2020/4/16.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCDropMenuCollectionCell.h"

@implementation FCDropMenuCollectionCell
- (UILabel *)textLa{
    if (!_textLa) {
        _textLa = [UILabel new];
        _textLa.font = [UIFont systemFontOfSize:13];
        _textLa.textAlignment = NSTextAlignmentCenter;
        _textLa.layer.masksToBounds = YES;
        _textLa.numberOfLines = 2;
        [self.contentView addSubview:_textLa];
    }
    return _textLa;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLa.frame = self.contentView.bounds;
    self.textLa.layer.cornerRadius = self.contentView.bounds.size.height/2.0;
}
@end
