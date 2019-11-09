//
//  GXAccountManageCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXFinanceLog;
@interface GXAccountManageCell : UITableViewCell
/* 明细 */
@property(nonatomic,strong) GXFinanceLog *log;
@end

NS_ASSUME_NONNULL_END
