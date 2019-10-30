//
//  GXStoreDetail.h
//  GX
//
//  Created by 夏增明 on 2019/10/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXStoreDetail : NSObject
@property(nonatomic,copy) NSString *shop_type;
@property(nonatomic,copy) NSString *shop_name;
@property(nonatomic,copy) NSString *shop_desc;
@property(nonatomic,copy) NSString *shop_address;
@property(nonatomic,copy) NSString *shop_front_img;
@property(nonatomic,copy) NSString *shop_inside_img;
@property(nonatomic,copy) NSString *food_license_img;
@property(nonatomic,copy) NSString *shop_open_time;
@property(nonatomic,copy) NSString *evl_level;
@property(nonatomic,copy) NSString *desc_level;
@property(nonatomic,copy) NSString *deliver_level;
@property(nonatomic,copy) NSString *answer_level;
@property(nonatomic,copy) NSString *evl_num;
@property(nonatomic,copy) NSString *town_name;
@property(nonatomic,copy) NSString *city_name;
@property(nonatomic,copy) NSString *province_name;
@property(nonatomic,copy) NSString *brand_name;

@end

NS_ASSUME_NONNULL_END
