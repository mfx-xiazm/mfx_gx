//
//  GXChooseClassFooter.h
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^buyNumCall)(NSInteger num);

@interface GXChooseClassFooter : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIView *numView;
@property (weak, nonatomic) IBOutlet UIView *storeCodeView;
@property (weak, nonatomic) IBOutlet UILabel *shop_code;
/* 库存 */
@property(nonatomic,assign) NSInteger stock_num;
@property (weak, nonatomic) IBOutlet UITextField *buy_num;
/* 点击 */
@property(nonatomic,copy) buyNumCall buyNumCall;
@end

NS_ASSUME_NONNULL_END
