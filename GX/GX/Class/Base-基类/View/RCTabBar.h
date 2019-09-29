//
//  RCTabBar.h
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCTabBar;
@protocol RCTabBarDelegate <UITabBarDelegate>
@optional

-(void)tabBarDidClickPlusButton:(RCTabBar *)tabBar;
@end

@interface RCTabBar : UITabBar
@property(nonatomic,weak)id <RCTabBarDelegate> rcDelegate;

@end

NS_ASSUME_NONNULL_END
