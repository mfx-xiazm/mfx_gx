//
//  GXRunCategoryView.h
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^runCateCall)(NSInteger index);
@interface GXRunCategoryView : UIView
/* 经营类目 */
@property(nonatomic,strong) NSArray *catalogItem;
/* 点击 */
@property(nonatomic,copy) runCateCall runCateCall;
@end

NS_ASSUME_NONNULL_END
