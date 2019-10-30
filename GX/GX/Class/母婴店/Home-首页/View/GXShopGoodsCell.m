//
//  GXShopGoodsCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXShopGoodsCell.h"
#import "GXHomeData.h"
#import "GXSearchResult.h"
#import "GXStore.h"

@interface GXShopGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
@implementation GXShopGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setGoods:(GYHomePushGoods *)goods
{
    _goods = goods;
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_goods.cover_img]];
    self.goods_name.text = _goods.goods_name;
    if ([_goods.control_type isEqualToString:@"1"]) {
        self.price.text = [NSString stringWithFormat:@"￥%@-￥%@",_goods.min_price,_goods.max_price];
    }else{
        self.price.text = [NSString stringWithFormat:@"￥%@",_goods.min_price];
    }
}
-(void)setSearch:(GXSearchResult *)search
{
    _search = search;
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_search.cover_img]];
    self.goods_name.text = _search.goods_name;
    if ([_search.control_type isEqualToString:@"1"]) {
        self.price.text = [NSString stringWithFormat:@"￥%@-￥%@",_search.min_price,_search.max_price];
    }else{
        self.price.text = [NSString stringWithFormat:@"￥%@",_search.min_price];
    }
}
-(void)setStoreGoods:(GXStoreGoods *)storeGoods
{
    _storeGoods = storeGoods;
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_storeGoods.cover_img]];
    self.goods_name.text = _storeGoods.goods_name;
    if ([_storeGoods.control_type isEqualToString:@"1"]) {
        self.price.text = [NSString stringWithFormat:@"￥%@-￥%@",_storeGoods.min_price,_storeGoods.max_price];
    }else{
        self.price.text = [NSString stringWithFormat:@"￥%@",_storeGoods.min_price];
    }
}
@end
