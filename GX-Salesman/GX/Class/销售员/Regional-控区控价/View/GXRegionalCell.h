//
//  GXRegionalCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GXGoodBrand,GXRegionalTry,GXRegionalWeekNewer;
@interface GXRegionalCell : UITableViewCell
/* 品牌 */
@property(nonatomic,strong) GXGoodBrand *brand;
/* 试新 */
@property(nonatomic,strong)  GXRegionalTry *rtry;
/* 上新 */
@property(nonatomic,strong) GXRegionalWeekNewer *week;
@end

NS_ASSUME_NONNULL_END
