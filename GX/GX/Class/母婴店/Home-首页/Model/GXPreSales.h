//
//  GXPreSales.h
//  GX
//
//  Created by huaxin-01 on 2020/6/23.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXPreSales : NSObject
@property(nonatomic,copy) NSString *sale_id;
@property(nonatomic,copy) NSString *presell_id;
@property(nonatomic,copy) NSString *goods_id;
// 状态：1未开始，2预售中,3已结束
@property(nonatomic,copy) NSString *sell_status;
@property(nonatomic,copy) NSString *begin_time;
@property(nonatomic,copy) NSString *end_time;
@property(nonatomic,copy) NSString *sell_num;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *control_type;
@property(nonatomic,copy) NSString *brand_id;
@property(nonatomic,copy) NSString *min_price;
@property(nonatomic,copy) NSString *max_price;
/// 倒计时秒数
@property (nonatomic, assign) NSInteger count;
/// 表示时间已经到了
@property (nonatomic, assign) BOOL timeOut;
/// 倒计时源
@property (nonatomic, copy) NSString *countDownSource;
@end

NS_ASSUME_NONNULL_END
