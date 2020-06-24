//
//  GXSalerOrder.h
//  GX
//
//  Created by 夏增明 on 2019/11/8.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXSalerOrder : NSObject
@property(nonatomic,copy) NSString *oid;
@property(nonatomic,copy) NSString *order_no;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *goods_num;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *specs_attrs;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *pay_amount;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *order_status;
@property(nonatomic,copy) NSString *provider_no;
@property(nonatomic,copy) NSString *shop_name;
@property(nonatomic,copy) NSString *refund_id;
@end

NS_ASSUME_NONNULL_END
