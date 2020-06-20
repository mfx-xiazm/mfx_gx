//
//  GXSearchTagHeader.h
//  GX
//
//  Created by 夏增明 on 2019/12/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^clearHistoryCall)(void);

@interface GXSearchTagHeader : UICollectionReusableView
/* 重新定位 */
@property(nonatomic,copy) clearHistoryCall clearHistoryCall;
@end

NS_ASSUME_NONNULL_END
