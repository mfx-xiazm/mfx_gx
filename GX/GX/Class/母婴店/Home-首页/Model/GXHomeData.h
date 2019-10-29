//
//  GXHomeData.h
//  GX
//
//  Created by 夏增明 on 2019/10/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GYHomeBanner,GYHomeTopCate,GYHomeDiscount,GYHomeRegional,GYHomeMarketTrend,GYHomeBrand,GYHomeActivity,GYHomePushGoods;
@interface GXHomeData : NSObject
@property(nonatomic,assign) BOOL homeUnReadMsg;
@property(nonatomic,strong) NSArray<GYHomeBanner *> *homeAdv;
@property(nonatomic,strong) NSArray<GYHomeTopCate *> *homeTopCate;
@property(nonatomic,strong) NSArray<GYHomeDiscount *> *home_rushbuy;
@property(nonatomic,strong) NSArray<GYHomeRegional *> *home_control_price_brand;
@property(nonatomic,strong) NSArray<GYHomeMarketTrend *> *currency_img;
@property(nonatomic,strong) NSArray<GYHomeBrand *> *home_brand_goods;
@property(nonatomic,strong) NSArray<GYHomeActivity *> *home_select_material;
@property(nonatomic,strong) NSArray<GYHomePushGoods *> *home_recommend_goods;

@end

@interface GYHomeBanner : NSObject
@property(nonatomic,copy) NSString *adv_id;
@property(nonatomic,copy) NSString *adv_name;
@property(nonatomic,copy) NSString *adv_img;
/** 1仅图片 2链接内容 3html富文本内容 4产品详情 */
@property(nonatomic,copy) NSString *adv_type;
@property(nonatomic,copy) NSString *adv_content;
@property(nonatomic,copy) NSString *ordid;
@property(nonatomic,copy) NSString *create_time;
@property(nonatomic,copy) NSString *root;
@end

@interface GYHomeTopCate : NSObject
@property(nonatomic,copy) NSString *cate_name;
@property(nonatomic,copy) NSString *image_name;
@end

@interface GYHomeDiscount : NSObject
@property(nonatomic,copy) NSString *home_set_id;
@property(nonatomic,copy) NSString *rush_cover_img;
@property(nonatomic,copy) NSString *rushbuy_id;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *rushbuy_status;
@property(nonatomic,copy) NSString *begin_time;
@property(nonatomic,copy) NSString *end_time;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *cover_img;

@end

@interface GYHomeRegional : NSObject
@property(nonatomic,copy) NSString *home_set_id;
@property(nonatomic,copy) NSString *ref_id;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *ordid;

@end

@interface GYHomeMarketTrend : NSObject
@property(nonatomic,copy) NSString *set_id;
@property(nonatomic,copy) NSString *set_type;
@property(nonatomic,copy) NSString *img;

@end

@interface GYHomeBrand : NSObject
@property(nonatomic,copy) NSString *home_set_id;
@property(nonatomic,copy) NSString *ref_id;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *ordid;

@end

@interface GYHomeActivity : NSObject
@property(nonatomic,copy) NSString *home_set_id;
@property(nonatomic,copy) NSString *ref_id;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *ordid;

@end

@interface GYHomePushGoods : NSObject
@property(nonatomic,copy) NSString *home_set_id;
@property(nonatomic,copy) NSString *ref_id;
@property(nonatomic,copy) NSString *set_cover_img;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *goods_name;
/** 1 常规商品 2控区控价商品 */
@property(nonatomic,copy) NSString *control_type;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *suggest_price;
@property(nonatomic,copy) NSString *min_price;
@property(nonatomic,copy) NSString *max_price;

@end
NS_ASSUME_NONNULL_END
