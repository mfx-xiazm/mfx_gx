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
/** 分享数量 */
@property(nonatomic,copy)NSString *shareNum;
/** 照片数组 */
@property(nonatomic,strong)NSArray *photos;
/** 是否已展开文字 */
@property (nonatomic, assign) BOOL isOpening;
/** 是否应该显示"全文" */
@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;

@property(nonatomic,copy) NSString *material_id;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *control_type;
@property(nonatomic,copy) NSString *material_title;
@property(nonatomic,copy) NSString *share_num;
@property(nonatomic,copy) NSString *material_desc;
@property(nonatomic,strong)NSArray *img;//material_img

@end

NS_ASSUME_NONNULL_END
