//
//  GXCategoryVC.m
//  GX
//
//  Created by 夏增明 on 2019/9/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXCategoryVC.h"
#import "GXBigCateCell.h"
#import "GXSmallCateCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GXSmallCateHeaderView.h"
#import "HXSearchBar.h"
#import "GXMessageVC.h"
#import "GXGoodsListVC.h"

static NSString *const BigCateCell = @"BigCateCell";
static NSString *const SmallCateCell = @"SmallCateCell";
static NSString *const SmallCateHeaderView = @"SmallCateHeaderView";

@interface GXCategoryVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate,UITextFieldDelegate>
/** 左边tableView */
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
/** 右边collectionView */
@property (weak, nonatomic) IBOutlet UICollectionView *rightCollectionView;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
/* 消息 */
@property(nonatomic,strong) SPButton *msgBtn;
@end

@implementation GXCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpCollectionView];
    
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
#pragma mark -- 页面设置
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH - 70.f, 30.f)];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 6;
    searchBar.layer.masksToBounds = YES;
    searchBar.delegate = self;
    self.searchBar = searchBar;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    
    SPButton *msg = [SPButton buttonWithType:UIButtonTypeCustom];
    msg.imagePosition = SPButtonImagePositionTop;
    msg.imageTitleSpace = 2.f;
    msg.hxn_size = CGSizeMake(40, 40);
    msg.titleLabel.font = [UIFont systemFontOfSize:9];
    [msg setImage:HXGetImage(@"消息") forState:UIControlStateNormal];
    [msg setTitle:@"消息" forState:UIControlStateNormal];
    [msg addTarget:self action:@selector(msgClicked) forControlEvents:UIControlEventTouchUpInside];
    [msg setTitleColor:UIColorFromRGB(0XFFFFFF) forState:UIControlStateNormal];
    
    self.msgBtn = msg;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:msg];
}
/** 页面设置 */
-(void)setUpTableView
{
    _leftTableView.backgroundColor = HXGlobalBg;
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.rowHeight = 44.f;
    _leftTableView.tableFooterView = [UIView new];
    _leftTableView.showsVerticalScrollIndicator = NO;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        _leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _leftTableView.estimatedSectionHeaderHeight = 0;
    _leftTableView.estimatedSectionFooterHeight = 0;
    [_leftTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXBigCateCell class]) bundle:nil] forCellReuseIdentifier:BigCateCell];
}
-(void)setUpCollectionView
{
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = YES;
    self.rightCollectionView.collectionViewLayout = flowLayout;
    self.rightCollectionView.dataSource = self;
    self.rightCollectionView.delegate = self;
    self.rightCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.rightCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXSmallCateCell class]) bundle:nil] forCellWithReuseIdentifier:SmallCateCell];
    [self.rightCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXSmallCateHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SmallCateHeaderView];
}
#pragma mark -- 点击事件
-(void)msgClicked
{
    GXMessageVC *mvc = [GXMessageVC new];
    [self.navigationController pushViewController:mvc animated:YES];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    HXLog(@"搜索条");
    return NO;
}
#pragma mark -- UITableView 数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXBigCateCell *cell = [tableView dequeueReusableCellWithIdentifier:BigCateCell forIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GXSmallCateCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:SmallCateCell forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GXGoodsListVC *lvc = [GXGoodsListVC new];
    [self.navigationController pushViewController:lvc animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.hxn_width - 10*4)/3.0;
    CGFloat height = width+40.f;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(0, 10, 0, 10);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString : UICollectionElementKindSectionHeader]){
        GXSmallCateHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SmallCateHeaderView forIndexPath:indexPath];
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 44);
}

@end
