//
//  GXGoodsFilterView.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXGoodsFilterView.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GXRunCategoryCell.h"
#import "GXChooseClassHeader.h"
#import "GXCatalogItem.h"

static NSString *const RunCategoryCell = @"RunCategoryCell";
static NSString *const ChooseClassHeader = @"ChooseClassHeader";

@interface GXGoodsFilterView ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/* 上一次选中的分类 */
@property(nonatomic,strong) GXCatalogItem *selectItem;
/* 上一次选中的二级分类 */
@property(nonatomic,strong) GXCatalogItem *selectSubItem;
/* 上一次选中的热门品牌 */
@property(nonatomic,strong) GXBrandItem *selectBrand;
@end
@implementation GXGoodsFilterView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXRunCategoryCell class]) bundle:nil] forCellWithReuseIdentifier:RunCategoryCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXChooseClassHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ChooseClassHeader];
}
- (IBAction)handleBtnClicked:(UIButton *)sender {
    if (sender.tag) {
        if (self.sureFilterCall) {
            if (self.dataType == 1) {
                self.sureFilterCall((self.selectItem && self.selectItem.isSelected)?self.selectItem.catalog_id:nil);
            }else if (self.dataType == 2) {
                self.sureFilterCall((self.selectSubItem && self.selectSubItem.isSelected)?self.selectSubItem.catalog_id:nil);
            }else if (self.dataType == 3){
               self.sureFilterCall((self.selectBrand && self.selectBrand.isSelected)?self.selectBrand.brand_id:nil);
            }
        }
        if (self.filterCall) {
            if (self.dataType == 4) {
                self.filterCall((self.selectItem && self.selectItem.isSelected)?self.selectItem.catalog_id:nil,(self.selectBrand && self.selectBrand.isSelected)?self.selectBrand.brand_id:nil);
            }
        }
    }else{
        if (self.dataType == 1) {
            self.selectItem.isSelected = NO;
        }else if (self.dataType == 2) {
            self.selectSubItem.isSelected = NO;
        }else if (self.dataType == 3){
            self.selectBrand.isSelected = NO;
        }else {
            self.selectItem.isSelected = NO;
            self.selectBrand.isSelected = NO;
        }
        [self.collectionView reloadData];
    }
}

-(void)setDataSouce:(NSArray *)dataSouce
{
    _dataSouce = dataSouce;
    self.selectItem = nil;
    self.selectSubItem = nil;
    self.selectBrand = nil;
    if (self.dataType == 1) {
        for (GXCatalogItem *item in _dataSouce) {
            if ([item.catalog_id isEqualToString:self.logItemId]) {
                item.isSelected = YES;
                self.selectItem = item;
            }else{
                item.isSelected = NO;
            }
        }
    }else if (self.dataType == 2) {
        for (GXCatalogItem *item in _dataSouce) {
            if ([item.catalog_id isEqualToString:self.logItemId]) {
                item.isSelected = YES;
                self.selectSubItem = item;
            }else{
                item.isSelected = NO;
            }
        }
    }else if (self.dataType == 3){
        for (GXBrandItem *item in _dataSouce) {
            if ([item.brand_id isEqualToString:self.brandItemId]) {
                item.isSelected = YES;
                self.selectBrand = item;
            }else{
                item.isSelected = NO;
            }
        }
    }else {
            for (GXCatalogItem *item in _dataSouce) {
                if ([item.catalog_id isEqualToString:self.logItemId]) {
                    item.isSelected = YES;
                    self.selectItem = item;
                }else{
                    item.isSelected = NO;
                }
            }
            if (self.selectItem) {
                for (GXBrandItem *item in self.selectItem.brandData) {
                    if ([item.brand_id isEqualToString:self.brandItemId]) {
                        item.isSelected = YES;
                        self.selectBrand = item;
                    }else{
                        item.isSelected = NO;
                    }
                }
            }
    }
    [self.collectionView reloadData];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.dataType == 1) {
        return 1;
    }else if (self.dataType == 2) {
        return 1;
    }else if (self.dataType == 3){
        return 1;
    }else{
        return 2;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataType == 1) {
        return self.dataSouce.count;
    }else if (self.dataType == 2) {
        return self.dataSouce.count;
    }else if (self.dataType == 3){
        return self.dataSouce.count;
    }else{
        if (section == 0) {
           return self.dataSouce.count;
        }else{
            return (self.selectItem && self.selectItem.isSelected)?self.selectItem.brandData.count:0;
        }
    }
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section
{
    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GXRunCategoryCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:RunCategoryCell forIndexPath:indexPath];
    if (self.dataType == 1) {
        GXCatalogItem *caItem = self.dataSouce[indexPath.item];
        cell.caItem = caItem;
    }else if (self.dataType == 2) {
        GXCatalogItem *logItem = self.dataSouce[indexPath.item];
        cell.logItem = logItem;
    }else if (self.dataType == 3){
        GXBrandItem *brandItem = self.dataSouce[indexPath.item];
        cell.brandItem = brandItem;
    }else{
        if (indexPath.section == 0) {
           GXCatalogItem *logItem = self.dataSouce[indexPath.item];
           cell.logItem = logItem;
        }else{
            GXBrandItem *brandItem = self.selectItem.brandData[indexPath.item];
            cell.brandItem = brandItem;
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataType == 1) {
        self.selectItem.isSelected = NO;
        GXCatalogItem *caItem = self.dataSouce[indexPath.item];
        caItem.isSelected = YES;
        self.selectItem = caItem;
    }else if (self.dataType == 2) {
        self.selectSubItem.isSelected = NO;
        GXCatalogItem *subItem = self.dataSouce[indexPath.item];
        subItem.isSelected = YES;
        self.selectSubItem = subItem;
    }else if (self.dataType == 3) {
        self.selectBrand.isSelected = NO;
        GXBrandItem *brandItem = self.dataSouce[indexPath.item];
        brandItem.isSelected = YES;
        self.selectBrand = brandItem;
    }else{
        if (indexPath.section == 0) {
            self.selectItem.isSelected = NO;
            GXCatalogItem *logItem = self.dataSouce[indexPath.item];
            logItem.isSelected = YES;
            self.selectItem = logItem;
            
            // 重置品牌
            self.selectBrand.isSelected = NO;
        }else{
            self.selectBrand.isSelected = NO;
            GXBrandItem *brandItem = self.selectItem.brandData[indexPath.item];
            brandItem.isSelected = YES;
            self.selectBrand = brandItem;
        }
    }
   
    [collectionView reloadData];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(HX_SCREEN_WIDTH,44.f);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        GXChooseClassHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ChooseClassHeader forIndexPath:indexPath];
        if (self.dataType == 1) {
            header.titleLabel.text = @"类目";
        }else if (self.dataType == 2) {
            header.titleLabel.text = @"分类";
        }else if (self.dataType == 3){
            header.titleLabel.text = @"品牌";
        }else{
            header.titleLabel.text = indexPath.section?@"品牌":@"分类";
        }
        return header;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((HX_SCREEN_WIDTH-10*2.f-5*2.f)/3.0, 34);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(5, 10, 5, 10);
}

@end
