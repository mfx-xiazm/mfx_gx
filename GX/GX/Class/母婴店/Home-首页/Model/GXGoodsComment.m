//
//  GXGoodsComment.m
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXGoodsComment.h"

@implementation GXGoodsComment
-(void)setDsp:(NSString *)dsp
{
    if (!dsp) {
        return;
    }
    _dsp = dsp;
    if (!_dsp.length) {
        _dsp = @"";
    }
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:_dsp];
    text.yy_font = [UIFont systemFontOfSize:14];// 文字大小
    text.yy_lineSpacing = 5;//行高
    
    YYTextContainer * container = [YYTextContainer containerWithSize:CGSizeMake(HX_SCREEN_WIDTH - 10*2, CGFLOAT_MAX)];
    
    YYTextLayout * layout = [YYTextLayout layoutWithContainer:container text:text];
    
    // 默认最多显示6行，大于6行折叠，并显示全文按钮
    if (layout.rowCount <= 6) {
        _shouldShowMoreButton = NO;
    }else{
        _shouldShowMoreButton = YES;
    }
}

- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}
@end
