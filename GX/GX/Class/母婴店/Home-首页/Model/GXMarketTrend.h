//
//  GXMarketTrend.h
//  GX
//
//  Created by 夏增明 on 2019/10/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMarketTrendSeries,GXSeriesGoods;
@interface GXMarketTrend : NSObject
/* 分组标记 */
@property(nonatomic,assign) NSInteger series_section;
@property(nonatomic,copy) NSString *brand_id;
@property(nonatomic,copy) NSString *catalog_id;
@property(nonatomic,copy) NSString *brand_name;
@property(nonatomic,strong) NSArray<GXMarketTrendSeries *> *series;

@end

@interface GXMarketTrendSeries : NSObject
/* 分组标记 */
@property(nonatomic,assign) NSInteger section_flag;
@property(nonatomic,copy) NSString *series_id;
@property(nonatomic,copy) NSString *brand_id;
@property(nonatomic,copy) NSString *series_name;
@property(nonatomic,copy) NSString *series_img;
@property(nonatomic,strong) NSArray<GXSeriesGoods *> *goods;
@end

@interface GXSeriesGoods : NSObject
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *sku_id;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *specs_attrs;
@end

NS_ASSUME_NONNULL_END
