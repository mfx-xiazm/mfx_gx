//
//  GXGoodsMaterial.h
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXGoodsMaterial : NSObject
/** 内容文本 */
@property(nonatomic,copy)NSString *dsp;
/** 用户昵称 */
@property(nonatomic,copy)NSString *nick;
/** 时间 */
@property(nonatomic,copy)NSString *creatTime;
/** 点赞分享数量 */
@property(nonatomic,copy)NSString *thumbNum;
/** 照片数组 */
@property(nonatomic,strong)NSArray *photos;
/** 是否已展开文字 */
@property (nonatomic, assign) BOOL isOpening;
/** 是否应该显示"全文" */
@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;
@end

NS_ASSUME_NONNULL_END
