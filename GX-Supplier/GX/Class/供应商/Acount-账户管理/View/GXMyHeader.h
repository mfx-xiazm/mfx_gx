//
//  GXMyHeader.h
//  GX
//
//  Created by huaxin-01 on 2020/6/18.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^headerBtnClicked)(NSInteger index);
@interface GXMyHeader : UIView
@property (nonatomic, assign) CGRect imageViewFrame;
@property (nonatomic, strong) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *cash_balance;
@property (nonatomic, copy) headerBtnClicked headerBtnClicked;
@end

NS_ASSUME_NONNULL_END
