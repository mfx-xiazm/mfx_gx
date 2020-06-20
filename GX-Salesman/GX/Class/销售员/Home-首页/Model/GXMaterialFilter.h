//
//  GXMaterialFilter.h
//  GX
//
//  Created by 夏增明 on 2019/10/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class GXCatalogItem,GXTopSaleMaterial;
@interface GXMaterialFilter : NSObject
@property(nonatomic,strong) NSArray<GXCatalogItem *> *catalog;
@property(nonatomic,strong) NSArray<GXTopSaleMaterial *> *advertise;
@property(nonatomic,strong) NSArray<GXTopSaleMaterial *> *plan;

@end

NS_ASSUME_NONNULL_END
