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
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *token;
/** 1 母婴店 2供应商 3销售员 */
@property (nonatomic,copy) NSString *utype;
@property (nonatomic,copy) NSString *approve_time;

@property (nonatomic,assign) NSInteger is_register;
/** '1入驻申请 2入驻提交(提交之后后台审核成功就直接进入第三步没有成功还是第二步 然后显示审核失败原因) 3签约(银行认证) 4签约(打款) 5签约(实名认证)) */
@property (nonatomic,assign) NSInteger step;
/** 1 待审核 2审核已通过 3审核驳回 */
@property (nonatomic,assign) NSInteger approve_status;

@end

