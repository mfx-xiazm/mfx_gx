//
//  GXDayDiscount.h
//  GX
//
//  Created by 夏增明 on 2019/10/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXDayDiscount : NSObject
@property(nonatomic,copy) NSString *rushbuy_id;
@property(nonatomic,copy) NSString *goods_id;
/** 1未开始 2进行中 3已结束 4暂停 */
@property(nonatomic,copy) NSString *rushbuy_status;
@property(nonatomic,copy) NSString *begin_time;
@property(nonatomic,copy) NSString *end_time;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *suggest_price;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *cover_img;

@end

NS_ASSUME_NONNULL_END
