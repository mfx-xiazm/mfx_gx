//
//  GXHomeSectionHeader.h
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZLCollectionReusableView.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXHomeSectionHeader : ZLCollectionReusableView
@property (weak, nonatomic) IBOutlet UIView *recommendView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImg;
@property (weak, nonatomic) IBOutlet UILabel *moreTitle;
@property (weak, nonatomic) IBOutlet UIImageView *moreImg;

@end

NS_ASSUME_NONNULL_END
