//
//  GXCartData.h
//  GX
//
//  Created by 夏增明 on 2019/11/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GXCartShopGoods,GXMyCoupon,GXCartSaleData,GXCartGoodsGift,GXCartGoodsRebate;
@interface GXCartData : NSObject

@property(nonatomic,copy) NSString *provider_uid;
@property(nonatomic,copy) NSString *shop_name;
@property(nonatomic,copy) NSString *totalCount;
@property(nonatomic,copy) NSString *getCount;
@property(nonatomic,copy) NSString *coupon;
@property(nonatomic,assign) BOOL is_checked;
@property(nonatomic,strong) NSArray<GXCartSaleData *> *sale_data;

@property(nonatomic,strong) NSArray<GXMyCoupon *> *coupons;

@end

@interface GXCartSaleData : NSObject
@property(nonatomic,strong) NSArray<GXCartShopGoods *> *goodsData;
@property(nonatomic,strong) NSArray<GXCartGoodsGift *> *giftData;
@property(nonatomic,strong) NSArray<GXCartGoodsRebate *> *rebate;
@end

@interface GXCartGoodsGift : NSObject
@property (nonatomic, copy) NSString *gift_rule_interval_id;
@property (nonatomic, copy) NSString *begin_num;
@property (nonatomic, copy) NSString *gift_num;
@property (nonatomic, copy) NSString *gift_type;
@property (nonatomic, copy) NSString *goods_name;
@end

@interface GXCartGoodsRebate : NSObject
@property (nonatomic, copy) NSString *rebate_id;
@property (nonatomic, copy) NSString *begin_price;
@property (nonatomic, copy) NSString *percent;
@property (nonatomic, copy) NSString *end_price;
@end

@interface GXCartShopGoods : NSObject
@property(nonatomic,copy) NSString *cart_id;
@property(nonatomic,copy) NSString *specs_attrs;
@property(nonatomic,copy) NSString *cart_num;
@property(nonatomic,assign) BOOL is_checked;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *control_type;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *stock;
@end
NS_ASSUME_NONNULL_END
