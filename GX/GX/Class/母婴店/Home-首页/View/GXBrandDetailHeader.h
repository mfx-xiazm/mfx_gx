//
//  GXBrandDetailHeader.h
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GXBrandDetail;
typedef void(^applyJoinCall)(void);
@interface GXBrandDetailHeader : UICollectionReusableView
/* 品牌基本信息 */
@property(nonatomic,strong) GXBrandDetail *brandDetail;
/* 申请加盟 */
@property(nonatomic,copy) applyJoinCall applyJoinCall;
@end

NS_ASSUME_NONNULL_END
