//
//  GXCashNote.h
//  GX
//
//  Created by huaxin-01 on 2020/6/23.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXCashNote : NSObject
@property(nonatomic,copy) NSString *finance_apply_id;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *utype;
// 1待审核；2已通过；3未通过
@property(nonatomic,copy) NSString *apply_status;
@property(nonatomic,copy) NSString *approve_time;
@property(nonatomic,copy) NSString *apply_amount;
@property(nonatomic,copy) NSString *bank_name;
@property(nonatomic,copy) NSString *card_no;
@property(nonatomic,copy) NSString *card_owner;
@property(nonatomic,copy) NSString *reject_reason;
@property(nonatomic,copy) NSString *create_time;
@property(nonatomic,copy) NSString *sub_bank_name;
@property(nonatomic,copy) NSString *pay_money_img;
@end

NS_ASSUME_NONNULL_END
