//
//  GXActivityCataInfo.h
//  GX
//
//  Created by 夏增明 on 2019/10/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class GXActivityBanner,GXCatalogItem;
@interface GXActivityCataInfo : NSObject
@property(nonatomic,strong) NSArray<GXActivityBanner *> *adv;
@property(nonatomic,strong) NSArray<GXCatalogItem *> *catalog;
@end

@interface GXActivityBanner : NSObject
@property(nonatomic,copy) NSString *adv_id;
@property(nonatomic,copy) NSString *adv_name;
@property(nonatomic,copy) NSString *adv_img;
@property(nonatomic,copy) NSString *adv_type;
@property(nonatomic,copy) NSString *adv_content;
@property(nonatomic,copy) NSString *ordid;
@property(nonatomic,copy) NSString *root;

@end
NS_ASSUME_NONNULL_END
