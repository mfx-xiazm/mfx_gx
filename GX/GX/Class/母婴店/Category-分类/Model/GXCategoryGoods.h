//
//  GXCategoryGoods.h
//  GX
//
//  Created by 夏增明 on 2019/10/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXCategoryGoods : NSObject
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *min_price;
@property(nonatomic,copy) NSString *max_price;
@property(nonatomic,copy) NSString *sale_num;
@property(nonatomic,copy) NSString *control_type;
@end

NS_ASSUME_NONNULL_END
