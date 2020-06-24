//
//  GXPresellChildVC.h
//  GX
//
//  Created by huaxin-01 on 2020/6/17.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXPresellChildVC : HXBaseViewController <JXPagerViewListViewDelegate>
/// 1预售中 2即将开始
@property (nonatomic, assign) NSInteger seaType;
@end

NS_ASSUME_NONNULL_END
