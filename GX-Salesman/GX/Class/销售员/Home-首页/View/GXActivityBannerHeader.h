//
//  GXActivityBannerHeader.h
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXActivityBanner;
typedef void(^activityBannerClicked)(NSInteger index);
@interface GXActivityBannerHeader : UIView
@property(nonatomic,strong) NSArray<GXActivityBanner *> *adv;
/* 顶部图 */
@property(nonatomic,strong) NSArray *tryCovers;
/* 点击 */
@property(nonatomic,copy) activityBannerClicked activityBannerClicked;
@end

NS_ASSUME_NONNULL_END
