//
//  GXGoodsDetail.h
//  GX
//
//  Created by 夏增明 on 2019/11/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GXGoodsDetailAdv,GXGoodsDetailParam,GXGoodsDetailSpec,GXGoodsDetailSubSpec,GXGoodsMaterial,GXGoodsMaterialLayout,GXGoodsComment,GXGoodsCommentLayout,GXGoodsLogisticst,GXGoodsDetailSku,GXGoodsRush,GXGoodsRecommend,GXGoodsGiftRule,GXGoodsRebate;
@interface GXGoodsDetail : NSObject
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *control_type;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *catalog_id;
@property(nonatomic,copy) NSString *sale_num;
@property(nonatomic,copy) NSString *series_id;
@property(nonatomic,copy) NSString *brand_id;
@property(nonatomic,copy) NSString *suggest_price;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *shelf_status;
@property(nonatomic,copy) NSString *min_price;
@property(nonatomic,copy) NSString *max_price;
@property(nonatomic,copy) NSString *important_notice;
@property(nonatomic,copy) NSString *goods_desc;
@property(nonatomic,copy) NSString *create_time;
@property(nonatomic,copy) NSString *evl_level;
@property(nonatomic,copy) NSString *desc_level;
@property(nonatomic,copy) NSString *deliver_level;
@property(nonatomic,copy) NSString *answer_level;
/**线下支付审核状态：1待上传打款凭证；2审核通过；3审核驳回。4上传打款凭证审核中；线上支付不需要审核逻辑*/
@property(nonatomic,copy) NSString *approve_status;
@property(nonatomic,copy) NSString *reject_reason;
@property(nonatomic,copy) NSString *rushbuy;
@property(nonatomic,copy) NSString *is_try;
@property(nonatomic,copy) NSString *collected;
@property(nonatomic,copy) NSString *is_join;
@property(nonatomic,copy) NSString *evaCount;
/** 购买的数量 */
@property(nonatomic,assign) NSInteger buyNum;
@property(nonatomic,strong) NSArray<GXGoodsRecommend *> *goods_recommend;
@property(nonatomic,strong) NSArray<GXGoodsGiftRule *> *gift_rule;
@property(nonatomic,strong) NSArray<GXGoodsRebate *> *rebate;
@property(nonatomic,strong) NSArray<GXGoodsDetailAdv *> *good_adv;
@property(nonatomic,strong) NSArray<GXGoodsDetailParam *> *good_param;
@property(nonatomic,strong) NSArray<GXGoodsDetailSpec *> *spec;
@property(nonatomic,strong) NSArray<GXGoodsMaterial *> *material;
@property(nonatomic,strong) NSArray<GXGoodsMaterialLayout *> *materialLayout;
@property(nonatomic,strong) NSArray<GXGoodsComment *> *eva;
@property(nonatomic,strong) NSArray<GXGoodsCommentLayout *> *evaLayout;
@property(nonatomic,strong) GXGoodsRush *rush;
@property(nonatomic,strong) NSArray<GXGoodsLogisticst *> *logistics;
/* 选中的分区的那个快递 */
@property(nonatomic,strong) GXGoodsLogisticst * _Nullable selectLogisticst;
/* 规格数据信息 */
@property(nonatomic,strong) GXGoodsDetailSku *sku;
@end

@interface GXGoodsDetailAdv : NSObject
@property(nonatomic,copy) NSString *goods_adv_id;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *adv_img;
// 1图片 2视频
@property(nonatomic,copy) NSString *adv_type;
@end

@interface GXGoodsDetailParam : NSObject
@property(nonatomic,copy) NSString *param_id;
@property(nonatomic,copy) NSString *param_name;
@property(nonatomic,copy) NSString *param_desc;
@end

@interface GXGoodsDetailSpec : NSObject
@property(nonatomic,copy) NSString *specs_id;
@property(nonatomic,copy) NSString *specs_name;
@property(nonatomic,strong) NSArray<GXGoodsDetailSubSpec *> *spec_val;
/* 选中的改分区的那个规格 */
@property(nonatomic,strong) GXGoodsDetailSubSpec *selectSpec;
@end

@interface GXGoodsDetailSubSpec : NSObject
@property(nonatomic,copy) NSString *attr_id;
@property(nonatomic,copy) NSString *attr_name;
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
@end

@interface GXGoodsDetailSku : NSObject
@property(nonatomic,copy) NSString *sku_id;
@property(nonatomic,copy) NSString *provider_no;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *stock;
@property(nonatomic,copy) NSString *control_type;
@property(nonatomic,copy) NSString *sale_id;
@property(nonatomic,copy) NSString *is_contry;
@property(nonatomic,copy) NSString *province_id;
@property(nonatomic,copy) NSString *city_id;
@property(nonatomic,copy) NSString *district_id;
@property(nonatomic,copy) NSString *town_id;

@property(nonatomic,strong) NSArray<GXGoodsLogisticst *> *logistic;

@end


@interface GXGoodsLogisticst : NSObject
@property(nonatomic,copy) NSString *freight_type;
@property(nonatomic,copy) NSString *freight_template_name;
@property(nonatomic,copy) NSString *freight_template_id;
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
@end

@interface GXGoodsRush : NSObject
@property(nonatomic,copy) NSString *rush_min_price;
@property(nonatomic,copy) NSString *rush_max_price;
/** 1未开始，2进行中；3已结束；4暂停 */
@property(nonatomic,copy) NSString *rushbuy_status;
@property(nonatomic,copy) NSString *begin_time;
@property(nonatomic,copy) NSString *end_time;
/** 倒计时 */
@property (nonatomic,assign) NSInteger countDown;
@end

@interface GXGoodsRecommend : NSObject
@property(nonatomic,copy) NSString *home_set_id;
@property(nonatomic,copy) NSString *ref_id;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *set_cover_img;
@property(nonatomic,copy) NSString *hogoods_idme_set_id;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *control_type;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *brand_id;
@property(nonatomic,copy) NSString *suggest_price;
@property(nonatomic,copy) NSString *min_price;
@property(nonatomic,copy) NSString *max_price;
@end

@interface GXGoodsGiftRule : NSObject
@property(nonatomic,copy) NSString *gift_rule_interval_id;
@property(nonatomic,copy) NSString *goods_gift_rule_id;
@property(nonatomic,copy) NSString *begin_num;
@property(nonatomic,copy) NSString *gift_type;
@property(nonatomic,copy) NSString *gift_num;
@property(nonatomic,copy) NSString *goods_name;
@end

@interface GXGoodsRebate : NSObject
@property(nonatomic,copy) NSString *rebate_id;
@property(nonatomic,copy) NSString *begin_price;
@property(nonatomic,copy) NSString *percent;
@end


NS_ASSUME_NONNULL_END
