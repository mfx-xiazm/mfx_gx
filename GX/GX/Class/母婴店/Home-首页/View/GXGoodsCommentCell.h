//
//  GXGoodsCommentCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GXGoodsCommentLayout,GXGoodsCommentCell;

@protocol GXGoodsCommentCellDelegate <NSObject>
@optional
/** 点击了全文/收回 */
- (void)didClickMoreLessInCommentCell:(GXGoodsCommentCell *)Cell;
@end

@interface GXGoodsCommentCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** 数据源 */
@property (nonatomic, strong) GXGoodsCommentLayout *commentLayout;
/** 代理 */
@property (nonatomic, assign) id<GXGoodsCommentCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
