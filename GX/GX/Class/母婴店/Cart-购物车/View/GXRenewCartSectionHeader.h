//
//  GXRenewCartSectionHeader.h
//  GX
//
//  Created by huaxin-01 on 2020/6/15.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXCartGoodsGift,GXCartGoodsRebate;
@interface GXRenewCartSectionHeader : UIView
@property (weak, nonatomic) IBOutlet UIView *dazengView;
@property (weak, nonatomic) IBOutlet UIView *fanliView;
@property (weak, nonatomic) IBOutlet UIView *doubleView;
@property(nonatomic,strong) NSArray<GXCartGoodsGift *> *giftData;
@property(nonatomic,strong) NSArray<GXCartGoodsRebate *> *rebate;
@end

NS_ASSUME_NONNULL_END
