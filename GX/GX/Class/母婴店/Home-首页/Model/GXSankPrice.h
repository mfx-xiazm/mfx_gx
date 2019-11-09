//
//  GXSankPrice.h
//  GX
//
//  Created by 夏增明 on 2019/11/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXSankPrice : NSObject
@property(nonatomic,copy)NSString *sale_id;
@property(nonatomic,copy)NSString *goods_id;
@property(nonatomic,copy)NSString *provider_uid;
@property(nonatomic,copy)NSString *unified_type;
@property(nonatomic,copy)NSString *sku_id;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *stock;
@property(nonatomic,copy)NSString *sale_num;
@property(nonatomic,copy)NSString *specs_attrs;
@property(nonatomic,copy)NSString *logistics_com_id;
/* 是否展开 */
@property(nonatomic,assign) BOOL isExpand;
@property(nonatomic,assign)NSInteger buy_num;
@property(nonatomic,copy)NSString *toatlPrice;

@end

NS_ASSUME_NONNULL_END
