//
//  GXMyIdeaVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMyIdeaVC.h"
#import "HXPlaceholderTextView.h"
#import "GXMyIdeaPhotoCell.h"
#import "GXMyIdeaTypeCell.h"
#import <ZLCollectionViewVerticalLayout.h>

static NSString *const MyIdeaPhotoCell = @"MyIdeaPhotoCell";
static NSString *const MyIdeaTypeCell = @"MyIdeaTypeCell";

@interface GXMyIdeaVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remarkText;
@property (weak, nonatomic) IBOutlet UICollectionView *typeCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeViewHeight;

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeight;

/* 照片 */
@property(nonatomic,strong) NSArray *photos;
@end

@implementation GXMyIdeaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的建议"];
    self.remarkText.placeholder = @"请输入反馈内容哦";
    self.photos = @[@""];
    [self setUpCollectionView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.typeViewHeight.constant = 35.f + self.typeCollectionView.contentSize.height;
        self.photoViewHeight.constant = 35.f + self.photoCollectionView.contentSize.height;
    });
}
-(void)setUpCollectionView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.typeCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    ZLCollectionViewVerticalLayout *flowLayout0 = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout0.delegate = self;
    flowLayout0.canDrag = NO;
    flowLayout0.header_suspension = NO;
    self.typeCollectionView.collectionViewLayout = flowLayout0;
    self.typeCollectionView.dataSource = self;
    self.typeCollectionView.delegate = self;
    
    [self.typeCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXMyIdeaTypeCell class]) bundle:nil] forCellWithReuseIdentifier:MyIdeaTypeCell];
    
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
#pragma mark -- 点击事件

#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.typeCollectionView) {
        return 7;
    }else{
        return self.photos.count;
    }
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    if (collectionView == self.typeCollectionView) {
        return LabelLayout;
    }else{
        return ClosedLayout;
    }
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    if (collectionView == self.typeCollectionView) {
        return 0;
    }else{
        return 4;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.typeCollectionView) {
        GXMyIdeaTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyIdeaTypeCell forIndexPath:indexPath];
        return cell;
    }else{
        GXMyIdeaPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyIdeaPhotoCell forIndexPath:indexPath];
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.typeCollectionView) {
        
    }else{
        self.photos = @[@"",@"",@"",@""];
        [collectionView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photoViewHeight.constant = 35.f + self.photoCollectionView.contentSize.height;
        });
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.typeCollectionView) {
       return CGSizeMake([@"产品建议" boundingRectWithSize:CGSizeMake(1000000, 26) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size.width + 20, 26);
    }else{
        CGFloat width = (collectionView.hxn_width-10*5.f)/4.0;
        CGFloat height = width;
        return CGSizeMake(width, height);
    }
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
