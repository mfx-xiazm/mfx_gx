//
//  GXCartSectionHeader.h
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^cartHeaderClickedCall)(NSInteger index);
@interface GXCartSectionHeader : UICollectionReusableView
/* 点击事件 */
@property(nonatomic,copy) cartHeaderClickedCall cartHeaderClickedCall;
@end

NS_ASSUME_NONNULL_END
