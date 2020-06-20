//
//  GXGoodsMaterialCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXGoodsMaterialLayout,GXGoodsMaterialCell;

@protocol GXGoodsMaterialCellDelegate <NSObject>
@optional
/** 查看商品 */
- (void)didClickGoodsInCell:(GXGoodsMaterialCell *)Cell;
/** 分享 */
- (void)didClickShareInCell:(GXGoodsMaterialCell *)Cell;
/** 点击了全文/收回 */
- (void)didClickMoreLessInCell:(GXGoodsMaterialCell *)Cell;
@end

@interface GXGoodsMaterialCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, weak) UIViewController *targetVc;
/** 数据源 */
@property (nonatomic, strong) GXGoodsMaterialLayout *materialLayout;
/** 代理 */
@property (nonatomic, assign) id<GXGoodsMaterialCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
