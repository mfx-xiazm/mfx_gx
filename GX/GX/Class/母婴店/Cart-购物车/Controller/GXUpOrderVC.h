//
//  GXUpOrderVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^upOrderSuccessCall)(void);
@interface GXUpOrderVC : HXBaseViewController
/* 购物车ID 选择多个用逗号隔开 */
@property(nonatomic,copy) NSString *cart_ids;
/* 直接购买商品id */
@property(nonatomic,copy) NSString *goods_id;
/* 直接购买商品数量 */
@property(nonatomic,copy) NSString *goods_num;
/* 直接购买商品规格 */
@property(nonatomic,copy) NSString *specs_attrs;
/* 直接购买该商品的规格id */
@property(nonatomic,copy) NSString *sku_id;
/* 直接购买物流公司id */
@property(nonatomic,copy) NSString *freight_template_id;
/* 购物车跳转 */
@property(nonatomic,assign) BOOL isCartPush;
/* 订单提交成功 */
@property(nonatomic,copy) upOrderSuccessCall upOrderSuccessCall;
@end

NS_ASSUME_NONNULL_END
