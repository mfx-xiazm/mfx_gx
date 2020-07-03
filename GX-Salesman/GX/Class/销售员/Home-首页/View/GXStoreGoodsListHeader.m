//
//  GXStoreGoodsListHeader.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXStoreGoodsListHeader.h"
#import <ZLCollectionViewHorzontalLayout.h>
#import "GXStore.h"

@interface GXStoreGoodsListHeader ()
@property (weak, nonatomic) IBOutlet UIImageView *shop_front_img;
@property (weak, nonatomic) IBOutlet UILabel *shop_name;
@property (weak, nonatomic) IBOutlet UILabel *evl_level;

@end
@implementation GXStoreGoodsListHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
}
- (IBAction)storeMsgClicked:(id)sender {
    if (self.storeMsgCall) {
     self.storeMsgCall();
    }
}
-(void)setStoreInfo:(GXStore *)storeInfo
{
    _storeInfo = storeInfo;
    [self.shop_front_img sd_setImageWithURL:[NSURL URLWithString:_storeInfo.shop_front_img] placeholderImage:HXGetImage(@"Icon-share")];
    self.shop_name.text = _storeInfo.shop_name;
    self.evl_level.text = [NSString stringWithFormat:@"综合评分：%@",_storeInfo.evl_level];
}

@end
