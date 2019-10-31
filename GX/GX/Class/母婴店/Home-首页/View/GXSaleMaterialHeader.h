//
//  GXSaleMaterialHeader.h
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^materialClickedCall)(NSInteger index);
@interface GXSaleMaterialHeader : UIView
/* 顶部素材 */
@property(nonatomic,strong) NSArray *topMaterials;
/* 点击 */
@property(nonatomic,copy) materialClickedCall materialClickedCall;
@end

NS_ASSUME_NONNULL_END
