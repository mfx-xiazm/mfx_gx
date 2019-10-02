//
//  GXChooseAddressView.h
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPProvince.h"
#import "SPCity.h"
#import "SPDistrict.h"

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

NS_ASSUME_NONNULL_BEGIN

@interface GXChooseAddressView : UIView
@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, copy) void(^lastComponentClickedBlock)(SPProvince *selectedProvince,SPCity *selectedCity,SPDistrict *selectedDistrict);
@end

NS_ASSUME_NONNULL_END
