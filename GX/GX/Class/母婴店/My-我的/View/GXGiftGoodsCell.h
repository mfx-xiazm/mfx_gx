//
//  GXGiftGoodsCell.h
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXGiftGoods;
@interface GXGiftGoodsCell : UITableViewCell
@property (nonatomic, strong) GXGiftGoods *giftGoods;
@property (weak, nonatomic) IBOutlet UIImageView *sharw_img;

@end

NS_ASSUME_NONNULL_END
