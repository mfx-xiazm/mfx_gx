//
//  GXClient.h
//  GX
//
//  Created by 夏增明 on 2019/11/8.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXClient : NSObject
@property(nonatomic,copy) NSString *shop_name;
@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *provider_no;
@property(nonatomic,copy) NSString *town_id;
@property(nonatomic,copy) NSString *shop_address;

@end

NS_ASSUME_NONNULL_END
