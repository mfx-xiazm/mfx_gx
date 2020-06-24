//
//  GXExpressShowView.h
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^expressShowCloseClicked)(void);
@interface GXExpressShowView : UIView
@property(nonatomic,copy) NSArray *logistics_nos;
@property (nonatomic, copy) expressShowCloseClicked expressShowCloseClicked;
@end

NS_ASSUME_NONNULL_END
