//
//  GXMyIdeaPhotoCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMyIdeaPhotoCell.h"
#import "GXShowProof.h"

@implementation GXMyIdeaPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setProof:(GXShowProof *)proof
{
    _proof = proof;
    [self.photoImg sd_setImageWithURL:[NSURL URLWithString:_proof.pay_img]];
}
@end
