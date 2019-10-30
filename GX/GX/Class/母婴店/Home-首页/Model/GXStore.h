//
//  GXStore.h
//  GX
//
//  Created by 夏增明 on 2019/10/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GXStoreGoods,GXStoreCoupons,GXCatalogItem;
@interface GXStore : NSObject
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *shop_name;
@property(nonatomic,copy) NSString *shop_front_img;
@property(nonatomic,copy) NSString *shop_desc;
@property(nonatomic,copy) NSString *evl_level;
@property(nonatomic,strong) NSArray<GXStoreGoods *> *goods;
@property(nonatomic,strong) NSArray<GXStoreCoupons *> *coupons;

@property(nonatomic,strong) NSArray<GXCatalogItem *> *catalog;
@property(nonatomic,strong) NSArray<GXStoreCoupons *> *coupon;
@end
       
@interface GXStoreGoods : NSObject
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *control_type;
@property(nonatomic,copy) NSString *suggest_price;
@property(nonatomic,copy) NSString *min_price;
@property(nonatomic,copy) NSString *max_price;

@end

@interface GXStoreCoupons : NSObject
@property(nonatomic,copy) NSString *rule_id;
@property(nonatomic,copy) NSString *coupon_name;
@property(nonatomic,copy) NSString *fulfill_amount;
@property(nonatomic,copy) NSString *coupon_amount;
@property(nonatomic,copy) NSString *valid_day;
@property(nonatomic,copy) NSString *expire_time;

@end
NS_ASSUME_NONNULL_END
