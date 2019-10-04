//
//  GXGoodsListVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXGoodsListVC.h"
#import "GXDiscountGoodsCell.h"
#import "GXGoodsDetailVC.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "HXSearchBar.h"
#import "GXGoodsFilterView.h"
#import <zhPopupController.h>

static NSString *const DiscountGoodsCell = @"DiscountGoodsCell";

@interface GXGoodsListVC ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
@end

@implementation GXGoodsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCollectionView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH - 70.f, 30.f)];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 6;
    searchBar.layer.masksToBounds = YES;
    searchBar.delegate = self;
    self.searchBar = searchBar;
    self.navigationItem.titleView = searchBar;
}
-(void)setUpCollectionView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXDiscountGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:DiscountGoodsCell];
}
#pragma mark -- 点击事件
- (IBAction)saleNumSankClicked:(UIButton *)sender {
    
}

- (IBAction)priceSankClicked:(UIButton *)sender {
    
}

- (IBAction)filterClicked:(UIButton *)sender {
    GXGoodsFilterView *fliter = [GXGoodsFilterView loadXibView];
    fliter.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-80, HX_SCREEN_HEIGHT);
    
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeRight;
    [self.zh_popupController presentContentView:fliter duration:0.25 springAnimated:NO];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    HXLog(@"搜索条");
    return NO;
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GXDiscountGoodsCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:DiscountGoodsCell forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
    [self.navigationController pushViewController:dvc animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = collectionView.hxn_width;
    CGFloat height = 120.f;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsZero;
}


@end
