//
//  GXBrandPartnerChildVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXBrandPartnerChildVC : HXBaseViewController
/* 类型 1查询已加盟 2查询所有*/
@property(nonatomic,assign) NSInteger dataType;
/* 分类id */
@property(nonatomic,copy) NSString *catalog_id;
@end

NS_ASSUME_NONNULL_END
