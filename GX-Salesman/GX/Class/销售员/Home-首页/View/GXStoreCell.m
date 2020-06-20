//
//  GXStoreCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXStoreCell.h"
#import "GXStore.h"

static NSString *const StoreCouponCell = @"StoreCouponCell";
@interface GXStoreCell ()
@property(nonatomic,weak) IBOutlet UILabel *shop_name;
@property(nonatomic,weak) IBOutlet UIImageView *shop_front_img;
@property(nonatomic,weak) IBOutlet UILabel *shop_coupon_desc;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *shop_goods_imgs;

@end
@implementation GXStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
}
- (IBAction)storeClicked:(UIButton *)sender {
    if (self.storeHandleCall) {
        self.storeHandleCall(sender.tag);
    }
}
-(void)setStore:(GXStore *)store
{
    _store = store;
    
    [self.shop_front_img sd_setImageWithURL:[NSURL URLWithString:_store.shop_front_img]];
    self.shop_name.text = _store.shop_name;
    self.shop_coupon_desc.text = _store.shop_desc;
    if (_store.goods.count) {
        for (int i=0;i<self.shop_goods_imgs.count;i++) {
            UIImageView *img = self.shop_goods_imgs[i];
            if (_store.goods.count >= i+1) {
                img.hidden = NO;
                GXStoreGoods *goods = _store.goods[i];
                [img sd_setImageWithURL:[NSURL URLWithString:goods.cover_img]];
            }else{
                img.hidden = YES;
                [img setImage:nil];
            }
        }
    }else{
        for (int i=0;i<self.shop_goods_imgs.count;i++) {
            UIImageView *img = self.shop_goods_imgs[i];
            img.hidden = YES;
            [img setImage:nil];
        }
    }
}

@end
