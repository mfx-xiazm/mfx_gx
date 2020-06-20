//
//  GXGoodBrandVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXGoodBrandVC.h"
#import "GXShopGoodsCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "HXSearchBar.h"
#import "GXGoodsDetailVC.h"
#import "HXDropMenuView.h"
#import "GXWebContentVC.h"
#import "GXCatalogItem.h"
#import "GXGoodBrand.h"
#import "GXBrandGoods.h"
#import "GXSearchResultVC.h"

static NSString *const ShopGoodsCell = @"ShopGoodsCell";

@interface GXGoodBrandVC ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate,HXDropMenuDelegate,HXDropMenuDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *cateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cateImg;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UIImageView *saleImg;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
/** 过滤 */
@property (nonatomic,strong) HXDropMenuView *menuView;
/** 选择的哪一个分类 */
@property (nonatomic,strong) UIButton *selectBtn;
/* 所有的分类 */
@property(nonatomic,strong) NSArray *cataItems;
/* 所有的品牌 */
@property(nonatomic,strong) NSArray *goodsBrands;
/* 分类id */
@property(nonatomic,strong) NSString *catalog_id;
/* 品牌id */
@property(nonatomic,strong) NSString *brand_id;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 列表 */
@property(nonatomic,strong) NSMutableArray *goods;
/* 销量排序 1升序 2倒序*/
@property(nonatomic,strong) NSString *sale_num;
@end

@implementation GXGoodBrandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCollectionView];
    [self setUpRefresh];
    [self startShimmer];
    [self getCatalogRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(void)setCatalog_id:(NSString *)catalog_id
{
    if (![_catalog_id isEqualToString:catalog_id]) {
        _catalog_id = catalog_id;
        hx_weakify(self);
        [self getGoodsListDataRequest:YES completedCall:^{
            hx_strongify(weakSelf);
            [strongSelf.collectionView reloadData];
        }];
    }
}
-(void)setBrand_id:(NSString *)brand_id
{
    if (![_brand_id isEqualToString:brand_id]) {
        _brand_id = brand_id;
        hx_weakify(self);
        [self getGoodsListDataRequest:YES completedCall:^{
            hx_strongify(weakSelf);
            [strongSelf.collectionView reloadData];
        }];
    }
}
-(NSMutableArray *)goods
{
    if (_goods == nil) {
        _goods = [NSMutableArray array];
    }
    return _goods;
}
-(HXDropMenuView *)menuView
{
    if (_menuView == nil) {
        _menuView = [[HXDropMenuView alloc] init];
        _menuView.dataSource = self;
        _menuView.delegate = self;
        _menuView.titleColor = UIColorFromRGB(0x131D2D);
        _menuView.titleHightLightColor = HXControlBg;
    }
    return _menuView;
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH - 55.f, 30.f)];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 15.f;
    searchBar.layer.masksToBounds = YES;
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入商品名称查询";
    self.searchBar = searchBar;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
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
    
    hx_weakify(self);
    [self.collectionView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
        [weakSelf startShimmer];
        [weakSelf getCatalogRequest];
    }];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.collectionView.mj_footer resetNoMoreData];
        [strongSelf getGoodsListDataRequest:YES completedCall:^{
            [strongSelf.collectionView reloadData];
        }];
    }];
    //追加尾部刷新
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getGoodsListDataRequest:NO completedCall:^{
            [strongSelf.collectionView reloadData];
        }];
    }];
}
#pragma mark -- 接口请求
-(void)getCatalogRequest
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 执行循序1
    hx_weakify(self);
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"searchType"] = @"1";//1为查询所有的分类 2位查询所有的品牌
        
        [HXNetworkTool POST:HXRC_M_URL action:@"program/getAllCatalogBrand" parameters:parameters success:^(id responseObject) {
            if([[responseObject objectForKey:@"status"] integerValue] == 1) {
                NSMutableArray *tampArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[GXCatalogItem class] json:responseObject[@"data"]]];
                GXCatalogItem *item = [[GXCatalogItem alloc] init];
                item.catalog_id = @"";
                item.catalog_name = @"全部";
                [tampArr insertObject:item atIndex:0];
                strongSelf.cataItems = tampArr;
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    // 执行循序2
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"searchType"] = @"2";//1为查询所有的分类 2位查询所有的品牌
        
        [HXNetworkTool POST:HXRC_M_URL action:@"program/getAllCatalogBrand" parameters:parameters success:^(id responseObject) {
            if([[responseObject objectForKey:@"status"] integerValue] == 1) {
                NSMutableArray *tampArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[GXGoodBrand class] json:responseObject[@"data"]]];
               
                GXGoodBrand *brand = [[GXGoodBrand alloc] init];
                brand.brand_id = @"";
                brand.brand_name = @"全部";
                [tampArr insertObject:brand atIndex:0];
                
                strongSelf.goodsBrands = tampArr;
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    // 执行循序3
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        [strongSelf getGoodsListDataRequest:YES completedCall:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        // 执行顺序10
        hx_strongify(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf stopShimmer];
            strongSelf.collectionView.hidden = NO;
            [strongSelf.collectionView reloadData];
        });
    });
    
}
-(void)getGoodsListDataRequest:(BOOL)isRefresh completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"catalog_id"] = (self.catalog_id && self.catalog_id.length)?self.catalog_id:@"";//分类id
    parameters[@"brand_id"] = (self.brand_id && self.brand_id.length)?self.brand_id:@"";//品牌id
    parameters[@"sale_num"] = (self.sale_num && self.sale_num.length)?self.sale_num:@"";//销量排序
    if (isRefresh) {
        [self.collectionView.mj_footer resetNoMoreData];
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"program/goodsList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.collectionView.mj_header endRefreshing];
                strongSelf.pagenum = 1;

                [strongSelf.goods removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXBrandGoods class] json:responseObject[@"data"]];
                [strongSelf.goods addObjectsFromArray:arrt];
            }else{
                [strongSelf.collectionView.mj_footer endRefreshing];
                strongSelf.pagenum ++;

                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXBrandGoods class] json:responseObject[@"data"]];
                    [strongSelf.goods addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
        if (completedCall) {
            completedCall();
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf.collectionView.mj_header endRefreshing];
        [strongSelf.collectionView.mj_footer endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        if (completedCall) {
            completedCall();
        }
    }];
}
#pragma mark -- 点击事件
- (IBAction)filterBtnClicked:(UIButton *)sender {
    if (self.menuView.show) {
        [self.menuView menuHidden];
        return;
    }
    self.selectBtn = sender;
    if (sender.tag == 1) {
        self.menuView.transformImageView = self.cateImg;
        self.menuView.titleLabel = self.cateLabel;
    }else {
        self.menuView.transformImageView = self.brandImg;
        self.menuView.titleLabel = self.brandLabel;
    }
    
    [self.menuView menuShowInSuperView:self.view];
}
- (IBAction)sankBtnClicked:(UIButton *)sender {
    /* 销量排序 1升序 2倒序*/
    if ([self.sale_num isEqualToString:@"2"]) {//降序
        self.sale_num = @"1";
        [self.saleImg setImage:HXGetImage(@"上红下黑")];
    }else{//升序
        self.sale_num = @"2";
        [self.saleImg setImage:HXGetImage(@"上黑下红")];
    }
    hx_weakify(self);
    [self getGoodsListDataRequest:YES completedCall:^{
        hx_strongify(weakSelf);
        [strongSelf.collectionView reloadData];
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField hasText]) {
        [textField resignFirstResponder];

        GXSearchResultVC *gvc = [GXSearchResultVC new];
        gvc.keyword = textField.text;
        [self.navigationController pushViewController:gvc animated:YES];
        return YES;
    }else{
        return NO;
    }
}
#pragma mark -- HXDropMenuDelegate
- (CGPoint)menu_positionInSuperView {
    return CGPointMake(0, 44);
}
-(NSString *)menu_titleForRow:(NSInteger)row {
    if (self.selectBtn.tag == 1) {
        GXCatalogItem *item = self.cataItems[row];
        return item.catalog_name;
    }else{
        GXGoodBrand *brand = self.goodsBrands[row];
        return brand.brand_name;
    }
}
-(NSInteger)menu_numberOfRows {
    if (self.selectBtn.tag == 1) {
        return self.cataItems.count;
    }else{
        return self.goodsBrands.count;
    }
}
- (void)menu:(HXDropMenuView *)menu didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectBtn.tag == 1) {
        GXCatalogItem *item = self.cataItems[indexPath.row];
        self.catalog_id = item.catalog_id;
    }else{
        GXGoodBrand *brand = self.goodsBrands[indexPath.row];
        self.brand_id = brand.brand_id;
    }
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goods.count;
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
    GXBrandGoods *brandGoods = self.goods[indexPath.item];
    cell.brandGoods = brandGoods;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
    GXBrandGoods *brandGoods = self.goods[indexPath.item];
    dvc.goods_id = brandGoods.goods_id;
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
    return  UIEdgeInsetsMake(5.f, 5.f, 15.f, 5.f);
}
@end
