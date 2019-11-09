//
//  GXValidAddressCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GXMyAddress;
@interface GXValidAddressCell : UITableViewCell
/* 地址 */
@property(nonatomic,strong) GXMyAddress *address;
@end

NS_ASSUME_NONNULL_END
