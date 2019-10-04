//
//  GXGoodsDetailSectionHeader.h
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^sectionClickCall)(void);
@interface GXGoodsDetailSectionHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/* 点击 */
@property(nonatomic,copy) sectionClickCall sectionClickCall;
@end

NS_ASSUME_NONNULL_END
