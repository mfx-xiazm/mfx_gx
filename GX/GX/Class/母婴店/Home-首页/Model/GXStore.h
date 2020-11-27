//
//  GXStore.h
//  GX
//
//  Created by 夏增明 on 2019/10/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GXStoreGoods,GXStoreCoupons,GXCatalogItem,GXStoreCustomer;
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
@property(nonatomic,strong) GXStoreCustomer * _Nullable provider_customer;

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


@interface GXStoreCustomer : NSObject
@property(nonatomic,copy) NSString *fromUrl;
@property(nonatomic,copy) NSString *urlTitle;
@property(nonatomic,copy) NSString *agent;
@property(nonatomic,copy) NSString *peerId;
@property(nonatomic,copy) NSString *accessId;

@end
NS_ASSUME_NONNULL_END
