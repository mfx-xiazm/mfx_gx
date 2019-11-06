//
//  GXHomeBannerHeader.h
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "ZLCollectionReusableView.h"

NS_ASSUME_NONNULL_BEGIN
@class GYHomeBanner;
typedef void(^bannerClickCall)(NSInteger item);
@interface GXHomeBannerHeader : ZLCollectionReusableView
@property(nonatomic,strong) NSArray<GYHomeBanner *> *homeAdv;
/* 点击 */
@property(nonatomic,copy) bannerClickCall bannerClickCall;
@end

NS_ASSUME_NONNULL_END
