//
//  GXMarketTrendHeader.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMarketTrendHeader.h"

@interface GXMarketTrendHeader()<JXCategoryViewDelegate>

@end
@implementation GXMarketTrendHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.cateSuperView addSubview:self.categoryView];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.categoryView.frame = self.cateSuperView.bounds;
}
-(JXCategoryTitleView *)categoryView
{
    if (_categoryView == nil) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.frame = self.cateSuperView.bounds;
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.titles = @[@"美赞成", @"美素佳儿", @"德国爱他美", @"诺优能", @"美赞成", @"美素佳儿"];
        _categoryView.titleFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _categoryView.titleColor = [UIColor blackColor];
        _categoryView.titleSelectedColor = HXControlBg;
        _categoryView.delegate = self;
    }
    return _categoryView;
}
/**
 点击选中的情况才会调用该方法
 
 @param categoryView categoryView对象
 @param index 选中的index
 */
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index
{
    if (self.cateClickedCall) {
        self.cateClickedCall(index);
    }
}
@end
