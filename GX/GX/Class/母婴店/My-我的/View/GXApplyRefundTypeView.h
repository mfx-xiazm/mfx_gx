//
//  GXApplyRefundTypeView.h
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^selectCall)(void);
@interface GXApplyRefundTypeView : UIView
@property (weak, nonatomic) IBOutlet UILabel *typeTitle;
@property (nonatomic, strong) UITextField *showTextField;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) selectCall selectCall;
@end

NS_ASSUME_NONNULL_END
