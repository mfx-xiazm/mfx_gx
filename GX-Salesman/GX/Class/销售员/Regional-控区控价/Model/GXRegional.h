//
//  GXRegional.h
//  GX
//
//  Created by 夏增明 on 2019/10/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class GXRegionalBanner,GXRegionalNotice,GXRegionalWeekNewer,GXRegionalTry;
@interface GXRegional : NSObject
@property(nonatomic,strong) NSArray<GXRegionalBanner *> *adv;
@property(nonatomic,strong) NSArray<GXRegionalNotice *> *notice;
@property(nonatomic,strong) GXRegionalWeekNewer *week_newer;
@property(nonatomic,strong) GXRegionalTry *try_cover;
@end

@interface GXRegionalBanner : NSObject
@property(nonatomic,copy) NSString *adv_id;
@property(nonatomic,copy) NSString *adv_name;
@property(nonatomic,copy) NSString *adv_img;
@property(nonatomic,copy) NSString *adv_type;
@property(nonatomic,copy) NSString *adv_content;
@property(nonatomic,copy) NSString *ordid;
@property(nonatomic,copy) NSString *create_time;
@property(nonatomic,copy) NSString *root;

@end

@interface GXRegionalNotice : NSObject
@property(nonatomic,copy) NSString *notice_id;
@property(nonatomic,copy) NSString *notice_title;

@end

@interface GXRegionalWeekNewer : NSObject
@property(nonatomic,copy) NSString *set_id;
@property(nonatomic,copy) NSString *week_newer;
@property(nonatomic,copy) NSString *brand_id;

@end

@interface GXRegionalTry : NSObject
@property(nonatomic,copy) NSString *set_id;
@property(nonatomic,copy) NSString *try_cover;
@property(nonatomic,copy) NSString *set_val3;

@end

NS_ASSUME_NONNULL_END
