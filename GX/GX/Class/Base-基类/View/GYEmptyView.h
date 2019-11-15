//
//  GYEmptyView.h
//  GY
//
//  Created by 夏增明 on 2019/11/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "ZXEmptyContentView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GYEmptyUIState) {
    GYUINoDataState,      // 无数据
    GYUIApiErrorState,   // 接口报错
    GYUINetErrorState,   // 网络报错
};

@interface GYEmptyView : ZXEmptyContentView

@end

NS_ASSUME_NONNULL_END
