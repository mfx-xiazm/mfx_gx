//
//  GXPayTypeCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXPayType;
@interface GXPayTypeCell : UITableViewCell
/* 支付方式 */
@property(nonatomic,strong) GXPayType *payType;
@end

NS_ASSUME_NONNULL_END
