//
//  GXMember.h
//  GX
//
//  Created by 夏增明 on 2019/11/1.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMemberLevel;
@interface GXMember : NSObject
@property(nonatomic,copy) NSString *order_price_amount;
@property(nonatomic,copy) NSString *key;
@property(nonatomic,copy) NSString *level_need;
@property(nonatomic,strong) NSArray<GXMemberLevel *> *level;
@end

@interface GXMemberLevel : NSObject
@property(nonatomic,copy) NSString *level_id;
@property(nonatomic,copy) NSString *level_name;
@property(nonatomic,copy) NSString *condition;
@property(nonatomic,copy) NSString *discount;
@property(nonatomic,copy) NSString *create_time;

@end

NS_ASSUME_NONNULL_END
