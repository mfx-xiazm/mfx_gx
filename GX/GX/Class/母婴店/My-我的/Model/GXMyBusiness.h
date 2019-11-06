//
//  GXMyBusiness.h
//  GX
//
//  Created by 夏增明 on 2019/11/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class GXMyBrandBusiness,GXMyCataBusiness;
@interface GXMyBusiness : NSObject
@property(nonatomic,copy) NSString *year_pay_amount;
@property(nonatomic,copy) NSString *month_pay_amount;
@property(nonatomic,strong) NSArray<GXMyBrandBusiness *> *brand;
@property(nonatomic,strong) NSArray<GXMyCataBusiness *> *catalog;

@end

@interface GXMyBrandBusiness : NSObject
@property(nonatomic,copy) NSString *brand_id;
@property(nonatomic,copy) NSString *brand_name;
@property(nonatomic,copy) NSString *year_pay_amount;
@property(nonatomic,copy) NSString *month_pay_amount;

@end

@interface GXMyCataBusiness : NSObject
@property(nonatomic,copy) NSString *catalog_id;
@property(nonatomic,copy) NSString *catalog_name;
@property(nonatomic,copy) NSString *year_pay_amount;
@property(nonatomic,copy) NSString *month_pay_amount;

@end
NS_ASSUME_NONNULL_END
