//
//  GXSearchResultVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXSearchResultVC : HXBaseViewController
/* 关键词 */
@property(nonatomic,copy) NSString *keyword;
/* 供应商id 全局搜素则不用传该参数 搜索供应商店铺商品时需传递该参数 */
@property(nonatomic,copy) NSString *provider_uid;
@end

NS_ASSUME_NONNULL_END
