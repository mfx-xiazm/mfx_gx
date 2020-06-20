//
//  GXActivityCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXActivity;
@interface GXActivityCell : UITableViewCell
/* 活动 */
@property(nonatomic,strong) GXActivity *activity;
@end

NS_ASSUME_NONNULL_END
