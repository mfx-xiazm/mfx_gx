//
//  GXMyIdeaPhotoCell.h
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GXShowProof;
@interface GXMyIdeaPhotoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImg;
@property (nonatomic, strong) GXShowProof *proof;
@end

NS_ASSUME_NONNULL_END
