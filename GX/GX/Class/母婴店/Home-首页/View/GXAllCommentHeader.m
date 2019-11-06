//
//  GXAllCommentHeader.m
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXAllCommentHeader.h"
#import "HCSStarRatingView.h"
#import "GXGoodsDetail.h"

@interface GXAllCommentHeader ()
@property (weak, nonatomic) IBOutlet HCSStarRatingView *desc_star;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *deliver_star;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *answer_star;
@property (weak, nonatomic) IBOutlet UILabel *desc_label;
@property (weak, nonatomic) IBOutlet UILabel *deliver_level;
@property (weak, nonatomic) IBOutlet UILabel *answer_level;
@end
@implementation GXAllCommentHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setGoodsDetail:(GXGoodsDetail *)goodsDetail
{
    _goodsDetail = goodsDetail;
    
    self.desc_star.value = [_goodsDetail.desc_level floatValue];
    self.desc_label.text = _goodsDetail.desc_level;
    
    self.deliver_star.value = [_goodsDetail.deliver_level floatValue];
    self.deliver_level.text = _goodsDetail.deliver_level;

    self.answer_star.value = [_goodsDetail.answer_level floatValue];
    self.answer_level.text = _goodsDetail.answer_level;
}
@end
