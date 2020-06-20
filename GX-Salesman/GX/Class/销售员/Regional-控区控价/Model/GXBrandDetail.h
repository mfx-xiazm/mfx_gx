//
//  GXBrandDetail.h
//  GX
//
//  Created by 夏增明 on 2019/10/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXBrandDetail : NSObject
@property(nonatomic,copy) NSString *brand_id;
@property(nonatomic,copy) NSString *brand_name;
@property(nonatomic,copy) NSString *brand_img;
@property(nonatomic,copy) NSString *brand_logo;
@property(nonatomic,copy) NSString *brand_desc;
@property(nonatomic,copy) NSString *create_time;
/** 0未加盟 1审核中 2合作中 3审核驳回 4合作取消 */
@property(nonatomic,copy) NSString *apply_status;
/** 审核驳回原因 */
@property(nonatomic,copy) NSString *reject_reason;
@property(nonatomic,copy) NSString *approve_time;
@property(nonatomic,copy) NSString *apply_time;
@property(nonatomic,copy) NSString *brand_join_desc;

@end

NS_ASSUME_NONNULL_END
