//
//  GXRegionNoticeCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXRegionNoticeCell.h"
#import "GXRegional.h"

@interface GXRegionNoticeCell ()
@property (weak, nonatomic) IBOutlet UILabel *noticeTxt;

@end
@implementation GXRegionNoticeCell

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setNotice:(GXRegionalNotice *)notice
{
    _notice = notice;
    self.noticeTxt.text = _notice.notice_title;
}
@end
