//
//  GXClientManageCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXClient;
@interface GXClientManageCell : UITableViewCell
/* 客户 */
@property(nonatomic,strong) GXClient *client;
@end

NS_ASSUME_NONNULL_END
