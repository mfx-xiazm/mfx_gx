//
//  GXMessageCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GXMessage;
@interface GXMessageCell : UITableViewCell
/* 消息 */
@property(nonatomic,strong) GXMessage *msg;
@end

NS_ASSUME_NONNULL_END
