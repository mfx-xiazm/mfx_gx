//
//  MSUserInfo.h
//  KYPX
//
//  Created by hxrc on 2018/2/9.
//  Copyright © 2018年 KY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSUserInfo : NSObject
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *token;
/** 1 母婴店 2供应商 3销售员 */
@property (nonatomic,copy) NSString *utype;
@end

