//
//  GXGoodsGiftCell.h
//  GX
//
//  Created by huaxin-01 on 2020/6/11.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXGoodsGiftRule,GXGoodsRebate;
@interface GXGoodsGiftCell : UITableViewCell
@property(nonatomic,strong) NSArray<GXGoodsGiftRule *> *gift_rule;
@property(nonatomic,strong) NSArray<GXGoodsRebate *> *rebate;
@end

NS_ASSUME_NONNULL_END
