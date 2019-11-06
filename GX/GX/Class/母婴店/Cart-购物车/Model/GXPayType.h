//
//  GXPayType.h
//  GX
//
//  Created by 夏增明 on 2019/11/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXPayType : NSObject
/* 1-4 */
@property(nonatomic,copy) NSString *payType;
/* 方式 */
@property(nonatomic,copy) NSString *typeName;
/* 图 */
@property(nonatomic,strong) UIImage *typeImg;
/* 是否选中 */
@property(nonatomic,assign) NSInteger isSelected;
@end

NS_ASSUME_NONNULL_END
