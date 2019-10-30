//
//  GXRegionNoticeCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYNoticeViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class GXRegionalNotice;
@interface GXRegionNoticeCell : GYNoticeViewCell
/* 公告 */
@property(nonatomic,strong) GXRegionalNotice *notice;
@end

NS_ASSUME_NONNULL_END
