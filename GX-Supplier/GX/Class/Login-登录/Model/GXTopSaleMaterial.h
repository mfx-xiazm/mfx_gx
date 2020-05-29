//
//  GXTopSaleMaterial.h
//  GX
//
//  Created by 夏增明 on 2019/10/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXTopSaleMaterial : NSObject
@property(nonatomic,copy) NSString *material_filter_id;
@property(nonatomic,copy) NSString *material_filter_name;
@property(nonatomic,copy) NSString *material_filter_img;
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
