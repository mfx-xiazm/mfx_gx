//
//  GXRegisterStore.h
//  GX
//
//  Created by 夏增明 on 2019/10/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GXSelectRegion;
@interface GXRegisterStore : NSObject
@property (nonatomic, copy) NSString *shop_type;//门店类型：1单门店；2连锁。供应商默认为1
@property (nonatomic, copy) NSString *shop_name;//主门店名称
@property (nonatomic, copy) NSString *shop_area;//店铺地址
@property (nonatomic, copy) NSString *shop_address;//店铺详细地址
@property (nonatomic, copy) NSString *month_turnover;//月度营业额
@property (nonatomic, copy) NSString *business_license_img;//营业执照图片
@property (nonatomic, copy) NSString *shop_front_img;//门店正面照
@property (nonatomic, copy) NSString *shop_inside_img;//门店内部照
@property (nonatomic, copy) NSString *card_front_img;//身份证正面照
@property (nonatomic, copy) NSString *card_back_img;//身份证背面照
@property (nonatomic, copy) NSString *food_license_img;//食品经营许可证
@property (nonatomic, copy) NSString *town_id;//店铺所属镇
@property (nonatomic, copy) NSString *catalogs;//经营类目 经营类目 多个catalog_id间用逗号隔开
/* 所有地区 */
@property(nonatomic,strong) GXSelectRegion *region;
@end

NS_ASSUME_NONNULL_END
