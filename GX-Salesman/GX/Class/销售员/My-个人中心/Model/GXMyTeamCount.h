//
//  GXMyTeamCount.h
//  GX
//
//  Created by huaxin-01 on 2020/6/24.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GXMyTeamArea;
@interface GXMyTeamCount : NSObject
@property (nonatomic, copy) NSString *p_count;
@property (nonatomic, copy) NSString *c_count;
@property (nonatomic, copy) NSString *d_count;
@property (nonatomic, strong) NSArray<GXMyTeamArea *> *areas;

@end

@interface GXMyTeamArea : NSObject
@property (nonatomic, copy) NSString *area_id;
@property (nonatomic, copy) NSString *area_name;
@property (nonatomic, copy) NSString *area_alias;

@end
NS_ASSUME_NONNULL_END
