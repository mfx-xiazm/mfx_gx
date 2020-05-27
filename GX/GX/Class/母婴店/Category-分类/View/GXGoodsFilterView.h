//
//  GXGoodsFilterView.h
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^sureFilterCall)(NSString * _Nullable cata_id);
typedef void(^filterCall)(NSString * _Nullable logItemId,NSString * _Nullable brandItemId);
@interface GXGoodsFilterView : UIView
/* 1 控区控价的合作品牌筛选 2分类页面的二级分类 3分类页面的热门品牌 4精选好店的数据筛选*/
@property(nonatomic,assign) NSInteger dataType;
/* 分类 */
@property(nonatomic,strong) NSArray *dataSouce;
/* 选择的id */
@property(nonatomic,copy) NSString *logItemId;
/* 选择的id */
@property(nonatomic,copy) NSString *brandItemId;
/* 确定 */
@property(nonatomic,copy) sureFilterCall sureFilterCall;
/* 确定 */
@property (nonatomic, copy) filterCall filterCall;
@end

NS_ASSUME_NONNULL_END
