//
//  GXMyAddress.h
//  GX
//
//  Created by 夏增明 on 2019/11/1.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXMyAddress : NSObject
@property(nonatomic,copy) NSString *address_id;
@property(nonatomic,copy) NSString *shop_uid;
@property(nonatomic,copy) NSString *receiver;
@property(nonatomic,copy) NSString *receiver_phone;
@property(nonatomic,copy) NSString *province_id;
@property(nonatomic,copy) NSString *city_id;
@property(nonatomic,copy) NSString *district_id;
@property(nonatomic,copy) NSString *town_id;
@property(nonatomic,copy) NSString *area_name;
@property(nonatomic,copy) NSString *address_detail;
@property(nonatomic,assign) BOOL is_default;
@property(nonatomic,copy) NSString *create_time;

@end

NS_ASSUME_NONNULL_END
