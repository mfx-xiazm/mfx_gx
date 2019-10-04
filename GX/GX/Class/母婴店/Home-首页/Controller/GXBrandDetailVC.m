//
//  GXBrandDetailVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXBrandDetailVC.h"
#import "GXShopGoodsCell.h"
#import "GXBrandDetailHeader.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GXGoodsDetailVC.h"

static NSString *const ShopGoodsCell = @"ShopGoodsCell";
static NSString *const BrandDetailHeader = @"BrandDetailHeader";

@interface GXBrandDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation GXBrandDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"品牌页"];
    [self setUpCollectionView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(void)setUpCollectionView
{
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXShopGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:ShopGoodsCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXBrandDetailHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BrandDetailHeader];

}
#pragma mark -- 点击事件

#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 2;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GXShopGoodsCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShopGoodsCell forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
    [self.navigationController pushViewController:dvc animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (HX_SCREEN_WIDTH-10*3)/2.0;
    CGFloat height = width+70.f;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(5.f, 5.f, 10.f, 5.f);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString : UICollectionElementKindSectionHeader]){
        GXBrandDetailHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BrandDetailHeader forIndexPath:indexPath];
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 320);
}

@end
