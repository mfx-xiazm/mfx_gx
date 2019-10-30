//
//  GXGoodsFilterView.h
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^sureFilterCall)(NSString *cata_id);
@interface GXGoodsFilterView : UIView
/* 1 控区控价的合作品牌筛选  */
@property(nonatomic,assign) NSInteger dataType;
/* 分类 */
@property(nonatomic,strong) NSArray *dataSouce;
/* 确定 */
@property(nonatomic,copy) sureFilterCall sureFilterCall;
@end

NS_ASSUME_NONNULL_END
