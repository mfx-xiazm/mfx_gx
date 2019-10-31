//
//  GXBigCateCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXCatalogItem;
@interface GXBigCateCell : UITableViewCell
/* 分类 */
@property(nonatomic,strong) GXCatalogItem *logItem;
@end

NS_ASSUME_NONNULL_END
