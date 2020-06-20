//
//  GXSankPriceSectionFooter.h
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXSankPrice;
typedef void(^priceSankHandleCall)(NSInteger index);
@interface GXSankPriceSectionFooter : UIView
/* 排序 */
@property(nonatomic,strong) GXSankPrice *sank;
/* 点击 */
@property(nonatomic,copy) priceSankHandleCall priceSankHandleCall;
@end

NS_ASSUME_NONNULL_END
