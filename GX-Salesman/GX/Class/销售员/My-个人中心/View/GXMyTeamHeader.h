//
//  GXMyTeamHeader.h
//  GX
//
//  Created by huaxin-01 on 2020/6/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMyTeamCount;
@interface GXMyTeamHeader : UIView
@property (nonatomic, assign) CGRect imageViewFrame;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) GXMyTeamCount *teamCount;

@end

NS_ASSUME_NONNULL_END
