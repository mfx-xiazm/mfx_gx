//
//  GXStoreCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXStoreCell.h"
#import "GXStoreCouponCell.h"
#import <ZLCollectionViewHorzontalLayout.h>
#import "GXStore.h"

static NSString *const StoreCouponCell = @"StoreCouponCell";

@interface GXStoreCell ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property(nonatomic,weak) IBOutlet UILabel *shop_name;
@property(nonatomic,weak) IBOutlet UIImageView *shop_front_img;
@property(nonatomic,weak) IBOutlet UILabel *shop_coupon_desc;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *shop_goods_imgs;

@end
@implementation GXStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    ZLCollectionViewHorzontalLayout *flowLayout = [[ZLCollectionViewHorzontalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXStoreCouponCell class]) bundle:nil] forCellWithReuseIdentifier:StoreCouponCell];
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
    if (_store.coupons && _store.coupons.count) {
        self.collectionView.hidden = NO;
        self.collectionViewHeight.constant = 60.f;
    }else{
        self.collectionView.hidden = YES;
        self.collectionViewHeight.constant = 0.f;
    }
    if (_store.goods.count) {
        for (int i=0;i<_store.goods.count;i++) {
            GXStoreGoods *goods = _store.goods[i];
            UIImageView *img = self.shop_goods_imgs[i];
            [img sd_setImageWithURL:[NSURL URLWithString:goods.cover_img]];
        }
    }else{
        for (int i=0;i<self.shop_goods_imgs.count;i++) {
            UIImageView *img = self.shop_goods_imgs[i];
            [img setImage:nil];
        }
    }
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.collectionView reloadData];
    });
}
#pragma mark -- UICollectionView 数据源和代理
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section
{
    return ClosedLayout;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.store.coupons.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GXStoreCouponCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:StoreCouponCell forIndexPath:indexPath];
    GXStoreCoupons *coupon = self.store.coupons[indexPath.item];
    cell.coupon = coupon;
    if (indexPath.item %3 == 0) {
        cell.coupon_bg_img.image = HXGetImage(@"coupon_bg_1");
    }else if (indexPath.item %3 == 1) {
        cell.coupon_bg_img.image = HXGetImage(@"coupon_bg_2");
    }else{
        cell.coupon_bg_img.image = HXGetImage(@"coupon_bg_3");
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GXStoreCoupons *coupon = self.store.coupons[indexPath.item];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"rule_id"] = coupon.rule_id;
    
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/drawCoupon" parameters:parameters success:^(id responseObject) {
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(125, 40);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
