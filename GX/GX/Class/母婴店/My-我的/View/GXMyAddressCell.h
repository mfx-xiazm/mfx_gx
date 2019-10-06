//
//  GXMyAddressCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^addressClickedCall)(NSInteger index);
@interface GXMyAddressCell : UITableViewCell
/* 点击 */
@property(nonatomic,copy) addressClickedCall addressClickedCall;
@end

NS_ASSUME_NONNULL_END
