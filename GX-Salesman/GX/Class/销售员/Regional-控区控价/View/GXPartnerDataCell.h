//
//  GXPartnerDataCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GXMyBusiness,GXMyBrandBusiness,GXMyCataBusiness;
@interface GXPartnerDataCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *titleView;
/* 概览 */
@property(nonatomic,strong) GXMyBusiness *myBusiness;
/* 品牌 */
@property(nonatomic,strong) GXMyBrandBusiness *brandBusiness;
/* 类目 */
@property(nonatomic,strong) GXMyCataBusiness *cateBusiness;
@end

NS_ASSUME_NONNULL_END
