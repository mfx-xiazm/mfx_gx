//
//  GXWebContentVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXWebContentVC : HXBaseViewController
/** url */
@property (nonatomic,copy) NSString *url;
/* 标题 */
@property(nonatomic,copy) NSString *navTitle;
@end

NS_ASSUME_NONNULL_END
