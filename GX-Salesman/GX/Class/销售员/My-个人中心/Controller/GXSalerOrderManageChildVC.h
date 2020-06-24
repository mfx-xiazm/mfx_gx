//
//  GXSalerOrderManageChildVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXSalerOrderManageChildVC : HXBaseViewController
/* 数据类型 1终端店 2供应商*/
@property(nonatomic,assign) NSInteger dataType;
@property (nonatomic, copy) NSString *status;
/* 关键词 */
@property(nonatomic,copy) NSString *seaKey;
@end

NS_ASSUME_NONNULL_END
