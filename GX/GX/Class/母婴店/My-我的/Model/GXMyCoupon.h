//
//  GXMyCoupon.h
//  GX
//
//  Created by 夏增明 on 2019/11/1.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXMyCoupon : NSObject
@property(nonatomic,copy) NSString *rule_id;
@property(nonatomic,copy) NSString *coupon_name;
@property(nonatomic,copy) NSString *fulfill_amount;
@property(nonatomic,copy) NSString *coupon_amount;
@property(nonatomic,copy) NSString *valid_day;
@property(nonatomic,copy) NSString *provider_uid;
@property(nonatomic,copy) NSString *deadline;
@property(nonatomic,copy) NSString *shop_name;
/* 查询类型 1查询可以领取 2查询可使用 3查询已使用 */
@property(nonatomic,assign) NSInteger seaType;
@end

NS_ASSUME_NONNULL_END
