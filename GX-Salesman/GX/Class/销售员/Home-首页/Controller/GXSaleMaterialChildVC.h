//
//  GXSaleMaterialChildVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXSaleMaterialChildVC : HXBaseViewController
/* 为1表示筛选全部 为2表示筛选购买过 为3表示筛选转发过 */
@property(nonatomic,assign) NSInteger dataType;
@end

NS_ASSUME_NONNULL_END
