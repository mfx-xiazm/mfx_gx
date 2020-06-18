//
//  GXShowMoneyProofVC.m
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXShowMoneyProofVC.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GXMyIdeaPhotoCell.h"

static NSString *const MyIdeaPhotoCell = @"MyIdeaPhotoCell";
@interface GXShowMoneyProofVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

@end

@implementation GXShowMoneyProofVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"打款凭证"];
    [self setUpCollectionView];
}
-(void)setUpCollectionView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.photoCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = NO;
    self.photoCollectionView.collectionViewLayout = flowLayout;
    self.photoCollectionView.dataSource = self;
    self.photoCollectionView.delegate = self;
    
    [self.photoCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXMyIdeaPhotoCell class]) bundle:nil] forCellWithReuseIdentifier:MyIdeaPhotoCell];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   return 5;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 2;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GXMyIdeaPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyIdeaPhotoCell forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.hxn_width-10*3.f)/2.0;
    CGFloat height = width;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(10, 10, 10, 10);
}
@end
