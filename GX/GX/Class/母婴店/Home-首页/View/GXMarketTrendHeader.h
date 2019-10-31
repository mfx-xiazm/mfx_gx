//
//  GXMarketTrendHeader.h
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView.h>

NS_ASSUME_NONNULL_BEGIN
@class GXMarketTrend;
typedef void(^cateClickedCall)(NSInteger index);
@interface GXMarketTrendHeader : UIView
/** 切换 */
@property (strong, nonatomic) JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet UIView *cateSuperView;
/* 点击分类 */
@property(nonatomic,copy) cateClickedCall cateClickedCall;
/* 行情 */
@property(nonatomic,strong) NSArray *trends;
@end

NS_ASSUME_NONNULL_END
