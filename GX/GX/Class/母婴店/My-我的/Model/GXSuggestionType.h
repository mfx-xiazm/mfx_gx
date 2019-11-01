//
//  GXSuggestionType.h
//  GX
//
//  Created by 夏增明 on 2019/11/1.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXSuggestionType : NSObject
@property(nonatomic,copy) NSString *suggestion_type;
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
