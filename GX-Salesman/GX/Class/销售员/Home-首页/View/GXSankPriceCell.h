//
//  GXSankPriceCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXSankPrice;
@interface GXSankPriceCell : UITableViewCell
/* 价格排序 */
@property(nonatomic,strong) GXSankPrice *sank;
@end

NS_ASSUME_NONNULL_END
