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
#import "GXCatalogItem.h"
#import "GXCategoryGoods.h"

static NSString *const DiscountGoodsCell = @"DiscountGoodsCell";

@interface GXGoodsListVC ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *sale_img;
@property (weak, nonatomic) IBOutlet UIImageView *price_img;
/* 筛选视图 */
@property(nonatomic,strong) GXGoodsFilterView *fliterView;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
/* 为1按照销量从高到低排序 其他则取消按照从高到低排序  销量排序 1降序 2升序 */
@property(nonatomic,copy) NSString *sale_num;
/* 按照价格排序 1降序 2升序 */
@property(nonatomic,copy) NSString *price;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 列表 */
@property(nonatomic,strong) NSMutableArray *goods;
/* 搜索的商品名 */
@property(nonatomic,copy) NSString *goods_name;
@end

@implementation GXGoodsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCollectionView];
    [self setUpRefresh];
    [self startShimmer];
    [self getGoodsListDataRequest:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(void)setGoods_name:(NSString *)goods_name
{
    if (![_goods_name isEqualToString:goods_name]) {
        _goods_name = goods_name;
        [self getGoodsListDataRequest:YES];
    }
}
-(NSMutableArray *)goods
{
    if (_goods == nil) {
        _goods = [NSMutableArray array];
    }
    return _goods;
}
-(GXGoodsFilterView *)fliterView
{
    if (_fliterView == nil) {
        _fliterView = [GXGoodsFilterView loadXibView];
        _fliterView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-80, HX_SCREEN_HEIGHT);
    }
    return _fliterView;
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
    
    hx_weakify(self);
    [self.collectionView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
        [weakSelf startShimmer];
        [weakSelf getGoodsListDataRequest:YES];
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
        [strongSelf getGoodsListDataRequest:YES];
    }];
    //追加尾部刷新
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getGoodsListDataRequest:NO];
    }];
}
#pragma mark -- 接口请求
-(void)getGoodsListDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"catalog_id"] = (self.catalog_id && self.catalog_id.length)?self.catalog_id:@"";//二级分类id
    parameters[@"brand_id"] = (self.brand_id && self.brand_id.length)?self.brand_id:@"";//品牌id
    parameters[@"sale_num"] = (self.sale_num && self.sale_num.length)?self.sale_num:@"";//为1按照销量从高到低排序 其他则取消按照从高到低排序
    parameters[@"price"] = (self.price && self.price.length)?self.price:@"";//按照价格排序
    parameters[@"goods_name"] = (self.goods_name && self.goods_name.length)?self.goods_name:@"";//根据商品名称筛选

    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/catalogBrandGoods" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.collectionView.mj_header endRefreshing];
                strongSelf.pagenum = 1;

                [strongSelf.goods removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXCategoryGoods class] json:responseObject[@"data"]];
                [strongSelf.goods addObjectsFromArray:arrt];
            }else{
                [strongSelf.collectionView.mj_footer endRefreshing];
                strongSelf.pagenum ++;

                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXCategoryGoods class] json:responseObject[@"data"]];
                    [strongSelf.goods addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.collectionView.hidden = NO;
                [strongSelf.collectionView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [strongSelf.collectionView.mj_header endRefreshing];
        [strongSelf.collectionView.mj_footer endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 点击事件
- (IBAction)saleNumSankClicked:(UIButton *)sender {
    self.price_img.image = HXGetImage(@"全黑");
    self.price = @"";
    
    /* 销量排序 1降序 2升序*/
    if ([self.sale_num isEqualToString:@"1"]) {
        self.sale_num = @"2";
        [self.sale_img setImage:HXGetImage(@"上红下黑")];
    }else{
        self.sale_num = @"1";
        [self.sale_img setImage:HXGetImage(@"上黑下红")];
    }
    [self getGoodsListDataRequest:YES];
}

- (IBAction)priceSankClicked:(UIButton *)sender {
    self.sale_img.image = HXGetImage(@"全黑");
    self.sale_num = @"";
    
    /* 销量排序 1降序 2升序*/
    if ([self.price isEqualToString:@"1"]) {
        self.price = @"2";
        [self.price_img setImage:HXGetImage(@"上红下黑")];
    }else{
        self.price = @"1";
        [self.price_img setImage:HXGetImage(@"上黑下红")];
    }
    [self getGoodsListDataRequest:YES];
}

- (IBAction)filterClicked:(UIButton *)sender {
    
    if (self.catalog_id) {
        self.fliterView.dataType = 3;
        self.fliterView.dataSouce = self.brands;
    }else{
        self.fliterView.dataType = 2;
        self.fliterView.dataSouce = self.catalogs;
    }
    hx_weakify(self);
    self.fliterView.sureFilterCall = ^(NSString * _Nonnull cata_id) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        if (strongSelf.catalog_id) {
            strongSelf.brand_id = cata_id;
        }else{
            strongSelf.catalog_id = cata_id;
        }
        [strongSelf getGoodsListDataRequest:YES];
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeRight;
    [self.zh_popupController presentContentView:self.fliterView duration:0.25 springAnimated:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    if ([textField hasText]) {
    [textField resignFirstResponder];
    self.goods_name = [textField hasText]?textField.text:@"";
    return YES;
    //    }else{
    //        return NO;
    //    }
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
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GXDiscountGoodsCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:DiscountGoodsCell forIndexPath:indexPath];
    GXCategoryGoods *goods = self.goods[indexPath.item];
    cell.goods = goods;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
    GXCategoryGoods *goods = self.goods[indexPath.item];
    dvc.goods_id = goods.goods_id;
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
