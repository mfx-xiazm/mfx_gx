//
//  GXSaleMaterialFilerView.h
//  GX
//
//  Created by 夏增明 on 2019/10/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXSaleMaterialFilerView,GXMaterialFilter;
@protocol GXSaleMaterialFilerDelegate <NSObject>

@required
//出现位置
- (CGPoint)filterMenu_positionInSuperView;
//点击事件
- (void)filterMenu:(GXSaleMaterialFilerView *)menu didSelectLogId:(NSString *)logId didSelectAdvertiseId:(NSString *)advertiseId didSelectPlanId:(NSString *)planId;

@end


@interface GXSaleMaterialFilerView : UIView
@property (nonatomic, strong) UIColor *titleHightLightColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign ,readonly) BOOL show;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *transformImageView;
@property (nonatomic, weak) id<GXSaleMaterialFilerDelegate> delegate;
/* 数据源 */
@property(nonatomic,strong) GXMaterialFilter *dataSource;
- (void)reloadData;
- (void)menuHidden;
- (void)menuShowInSuperView:(UIView * _Nullable)view;
@end

NS_ASSUME_NONNULL_END
