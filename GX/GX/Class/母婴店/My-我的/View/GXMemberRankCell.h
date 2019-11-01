//
//  GXMemberRankCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMemberLevel;
@interface GXMemberRankCell : UITableViewCell
/* 会员 */
@property(nonatomic,strong) GXMemberLevel *level;
/* 当前等级 */
@property(nonatomic,copy) NSString *current_level_id;
/* 当前消费 */
@property(nonatomic,copy) NSString *price_amount;

@end

NS_ASSUME_NONNULL_END
