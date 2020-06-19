//
//  FCDropMenuRangeCollectionCell.h
//  FC
//
//  Created by huaxin-01 on 2020/4/16.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^FCMenuTextFieldCellBlock)(UITextField *textField,NSString *string);
@interface FCDropMenuRangeCollectionCell : UICollectionViewCell
@property(nonatomic,copy)NSString *lowT;
@property(nonatomic,copy)NSString *highT;
@property(nonatomic,strong)UITextField *lowText;
@property(nonatomic,strong)UILabel *lineLa;
@property(nonatomic,strong)UITextField *highText;
@property(nonatomic,copy)FCMenuTextFieldCellBlock fieldBlock;
@property (nonatomic, assign) BOOL isShowPicker;// 是弹出键盘还是弹出一个自定义的picker
@end

NS_ASSUME_NONNULL_END
