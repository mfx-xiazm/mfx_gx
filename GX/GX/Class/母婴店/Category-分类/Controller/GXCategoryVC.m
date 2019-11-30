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
#import "GXCatalogItem.h"

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
/* 分类 */
@property(nonatomic,strong) NSArray *catalogItems;
/* 当前选中的大分类 */
@property(nonatomic,strong) GXCatalogItem *currentCatalogItem;
@end

@implementation GXCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpCollectionView];
    [self startShimmer];
    [self getCatalogItemRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
#pragma mark -- 页面设置
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"分类"];
    
    /*
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
     */
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
#pragma mark -- 接口请求
-(void)getCatalogItemRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getCatalogItem" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXCatalogItem class] json:responseObject[@"data"]];
            
            NSMutableArray *tampArr = [NSMutableArray arrayWithArray:arrt];
            GXCatalogItem *item = [[GXCatalogItem alloc] init];
            item.catalog_name = @"控区控价";
            [tampArr insertObject:item atIndex:0];
            
            strongSelf.catalogItems = tampArr;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.leftTableView reloadData];
                [strongSelf.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                [strongSelf tableView:strongSelf.leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getCatalogBrandRequest:(NSString *)control catalogId:(NSString *)catalog_id
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"control"] = control;//为1表示点击控区控价查询控区控价下的品牌列表
    if (![control isEqualToString:@"1"]) {
        parameters[@"catalog_id"] = catalog_id;
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getCatalogBrand" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.currentCatalogItem.catalog = [NSArray yy_modelArrayWithClass:[GXCatalogItem class] json:responseObject[@"data"][@"catalog"]];
            strongSelf.currentCatalogItem.control = [NSArray yy_modelArrayWithClass:[GXBrandItem class] json:responseObject[@"data"][@"control"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.rightCollectionView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView 数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.catalogItems.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXBigCateCell *cell = [tableView dequeueReusableCellWithIdentifier:BigCateCell forIndexPath:indexPath];
    GXCatalogItem *logItem = self.catalogItems[indexPath.row];
    cell.logItem = logItem;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    GXCatalogItem *logItem = self.catalogItems[indexPath.row];
    if (logItem.control && logItem.catalog) {
        self.currentCatalogItem = logItem;
        [self.rightCollectionView reloadData];
    }else{
//        if (self.currentCatalogItem && ![self.currentCatalogItem isEqual:logItem] && (!self.currentCatalogItem.control || self.currentCatalogItem.catalog)) {
//            return;
//        }
        self.currentCatalogItem = logItem;
        if (indexPath.row) {
            [self getCatalogBrandRequest:@"0" catalogId:logItem.catalog_id];
        }else{
            [self getCatalogBrandRequest:@"1" catalogId:@""];
        }
    }
    
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.currentCatalogItem.catalog.count;
    }else{
        return self.currentCatalogItem.control.count;
    }
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GXSmallCateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SmallCateCell forIndexPath:indexPath];
    if (indexPath.section == 0) {
        GXCatalogItem *caItem = self.currentCatalogItem.catalog[indexPath.item];
        cell.caItem = caItem;
    }else{
        GXBrandItem *brand = self.currentCatalogItem.control[indexPath.item];
        cell.brand = brand;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GXGoodsListVC *lvc = [GXGoodsListVC new];
    if (indexPath.section == 0) {
        GXCatalogItem *caItem = self.currentCatalogItem.catalog[indexPath.item];
        lvc.catalog_id = caItem.catalog_id;
        lvc.brands = self.currentCatalogItem.control;
    }else{
        GXBrandItem *brand = self.currentCatalogItem.control[indexPath.item];
        lvc.brand_id = brand.brand_id;
        lvc.isControl = [self.currentCatalogItem.catalog_name isEqualToString:@"控区控价"]?YES:NO;
        lvc.catalogs = self.currentCatalogItem.catalog;
    }
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
        if (indexPath.section == 0) {
            headerView.cate_name.text = @"分类";
            return self.currentCatalogItem.catalog.count?headerView:nil;
        }else{
            headerView.cate_name.text = @"热门品牌";
            return self.currentCatalogItem.control.count?headerView:nil;
        }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.currentCatalogItem.catalog.count?CGSizeMake(collectionView.frame.size.width, 44):CGSizeZero;
    }else{
        return self.currentCatalogItem.control.count?CGSizeMake(collectionView.frame.size.width, 44):CGSizeZero;
    }
}

@end
