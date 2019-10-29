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
@interface GXHomeBannerHeader : ZLCollectionReusableView
@property(nonatomic,strong) NSArray<GYHomeBanner *> *homeAdv;
@end

NS_ASSUME_NONNULL_END
