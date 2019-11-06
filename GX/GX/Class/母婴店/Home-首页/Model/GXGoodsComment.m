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

-(void)setShop_name:(NSString *)shop_name
{
    _shop_name = shop_name;
    _nick = _shop_name;
}

-(void)setShop_front_img:(NSString *)shop_front_img
{
    _shop_front_img = shop_front_img;
    _portrait = _shop_front_img;
}

-(void)setEvl_content:(NSString *)evl_content
{
    _evl_content = evl_content;
    _dsp = (_evl_content.length)?_evl_content:@"";
}

-(void)setCreate_time:(NSString *)create_time
{
    _create_time = create_time;
    _creatTime = _create_time;
}

-(void)setEvaImgData:(NSArray *)evaImgData
{
    _evaImgData = evaImgData;
    
    NSMutableArray *tamp = [NSMutableArray array];
    for (NSDictionary *dict in _evaImgData) {
        [tamp addObject:dict[@"img_src"]];
    }
    _photos = [NSArray arrayWithArray:tamp];
}
@end
