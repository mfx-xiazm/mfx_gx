//
//  GXMessage.h
//  GX
//
//  Created by 夏增明 on 2019/10/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXMessage : NSObject
@property(nonatomic,copy) NSString *msg_id;
@property(nonatomic,copy) NSString *msg_title;
/** 0不关联 1订单详情 2退款订单详情 3优惠券发放 */
@property(nonatomic,copy) NSString *ref_type;
@property(nonatomic,copy) NSString *ref_id;
@property(nonatomic,copy) NSString *msg_content;
@property(nonatomic,copy) NSString *create_time;
/** 1已读 2未读 */
@property(nonatomic,copy) NSString *isRead;

@end

NS_ASSUME_NONNULL_END
