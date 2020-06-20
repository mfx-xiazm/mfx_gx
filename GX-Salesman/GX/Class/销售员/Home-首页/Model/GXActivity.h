//
//  GXActivity.h
//  GX
//
//  Created by 夏增明 on 2019/10/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXActivity : NSObject
@property(nonatomic,copy) NSString *material_id;
@property(nonatomic,copy) NSString *material_title;
@property(nonatomic,copy) NSString *cover_img;

@property(nonatomic,copy) NSString *m_cover_img;
@property(nonatomic,copy) NSString *inner_img;
@property(nonatomic,copy) NSString *material_desc;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *suggest_price;
@property(nonatomic,copy) NSString *min_price;
@property(nonatomic,copy) NSString *max_price;
@property(nonatomic,copy) NSString *control_type;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *stock;

@end

NS_ASSUME_NONNULL_END
