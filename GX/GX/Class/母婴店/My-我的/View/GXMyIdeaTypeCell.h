//
//  GXMyIdeaTypeCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GXSuggestionType;
@interface GXMyIdeaTypeCell : UICollectionViewCell
/* 类型 */
@property(nonatomic,strong) GXSuggestionType *type;
@end

NS_ASSUME_NONNULL_END
