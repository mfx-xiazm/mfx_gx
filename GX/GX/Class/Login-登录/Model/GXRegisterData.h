//
//  GXRegisterData.h
//  GX
//
//  Created by 夏增明 on 2019/11/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GXCatalogItem,GXPlatAccount,GXProviderType;
@interface GXRegisterData : NSObject

@property(nonatomic,strong) NSArray<GXCatalogItem *> *catalog;

@property(nonatomic,strong) GXPlatAccount *account;

@property(nonatomic,strong) NSArray<GXProviderType *> *provider_type;
   
@end

@interface GXPlatAccount : NSObject
@property (nonatomic, copy) NSString *set_id;
@property (nonatomic, copy) NSString *set_type;
@property (nonatomic, copy) NSString *set_val;
@property (nonatomic, copy) NSString *set_val2;
@property (nonatomic, copy) NSString *set_val3;
@property (nonatomic, copy) NSString *set_val4;

@end

@interface GXProviderType : NSObject
@property (nonatomic, copy) NSString *provider_type_id;
@property (nonatomic, copy) NSString *provider_type_name;
@property (nonatomic, copy) NSString *deposit_amount;

@end
NS_ASSUME_NONNULL_END
