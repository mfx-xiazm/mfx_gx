//
//  GXSearchResult.h
//  GX
//
//  Created by 夏增明 on 2019/10/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXSearchResult : NSObject

@property(nonatomic,copy) NSString *important_notice;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *goods_name;
/** 1 常规商品 2控区控价商品 */
@property(nonatomic,copy) NSString *control_type;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *suggest_price;
@property(nonatomic,copy) NSString *min_price;
@property(nonatomic,copy) NSString *max_price;

@end

NS_ASSUME_NONNULL_END
