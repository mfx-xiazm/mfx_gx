//
//  GXAllMaterialVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXAllMaterialVC : HXBaseViewController
/* 是否是搜索 */
@property(nonatomic,assign) BOOL isSearch;
/* 分类id */
@property(nonatomic,copy) NSString *catalog_id;
/* 商品id */
@property(nonatomic,copy) NSString *goods_id;
@end

NS_ASSUME_NONNULL_END
