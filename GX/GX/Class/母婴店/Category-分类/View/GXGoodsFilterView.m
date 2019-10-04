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

static NSString *const RunCategoryCell = @"RunCategoryCell";
static NSString *const ChooseClassHeader = @"ChooseClassHeader";

@interface GXGoodsFilterView ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/* 类目 */
@property(nonatomic,strong) NSArray *cates;

@end
@implementation GXGoodsFilterView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.cates = @[@"规格",@"大规格2",@"非常规格3",@"小规格4",@"超长规格5",@"规格6",@"规格7",@"规格8",@"规格9",@"规格10",@"规格11"];
    
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXRunCategoryCell class]) bundle:nil] forCellWithReuseIdentifier:RunCategoryCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXChooseClassHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ChooseClassHeader];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cates.count;
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
    cell.contentText.text = self.cates[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(HX_SCREEN_WIDTH,44.f);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        GXChooseClassHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ChooseClassHeader forIndexPath:indexPath];
        if (indexPath.section==0) {
            header.titleLabel.text = @"类目";
        }else if (indexPath.section==1) {
            header.titleLabel.text = @"分类";
        }else{
            header.titleLabel.text = @"品牌";
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
