//
//  GXStoreGoodsChildVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXStoreGoodsChildVC.h"
#import "GXShopGoodsCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GXStore.h"
#import "GXGoodsDetailVC.h"
#import "GXStoreMsgVC.h"
#import "GXSearchResultVC.h"
#import "HXSearchBar.h"
#import "GXStoreGoodsListHeader.h"

static NSString *const ShopGoodsCell = @"ShopGoodsCell";
static NSString *const StoreGoodsListHeader = @"StoreGoodsListHeader";
@interface GXStoreGoodsChildVC ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 列表 */
@property(nonatomic,strong) NSMutableArray *storeGoods;
/** 店铺基本信息 */
@property(nonatomic,strong) GXStore *storeInfo;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
@end

@implementation GXStoreGoodsChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCollectionView];
    [self setUpRefresh];
    [self startShimmer];
    [self getShopInfoRequest];
}
-(NSMutableArray *)storeGoods
{
    if (_storeGoods == nil) {
        _storeGoods = [NSMutableArray array];
    }
    return _storeGoods;
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
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXStoreGoodsListHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:StoreGoodsListHeader];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXShopGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:ShopGoodsCell];
    
    hx_weakify(self);
    [self.collectionView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
        [weakSelf startShimmer];
        [weakSelf getShopInfoRequest];
    }];
}
-(void)setUpNavBar
{
    self.hbd_barAlpha = 0.0;
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_tintColor = [UIColor blackColor];
    
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
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.collectionView.mj_footer resetNoMoreData];
        [strongSelf getCatalogGoodsDataRequest:YES completedCall:^{
            [strongSelf.collectionView reloadData];
        }];
    }];
    //追加尾部刷新
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getCatalogGoodsDataRequest:NO completedCall:^{
            [strongSelf.collectionView reloadData];
        }];
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField hasText]) {
        [textField resignFirstResponder];

        GXSearchResultVC *gvc = [GXSearchResultVC new];
        gvc.keyword = textField.text;
        gvc.provider_uid = self.provider_uid;
        [self.navigationController pushViewController:gvc animated:YES];
        return YES;
    }else{
        return NO;
    }
}
#pragma mark -- 数据请求
-(void)getShopInfoRequest
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 执行循序1
    hx_weakify(self);
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"provider_uid"] = self.provider_uid;// 店铺id

        [HXNetworkTool POST:HXRC_M_URL action:@"program/shopData" parameters:parameters success:^(id responseObject) {
            [strongSelf stopShimmer];
            if([[responseObject objectForKey:@"status"] integerValue] == 1) {
                strongSelf.storeInfo = [GXStore yy_modelWithDictionary:responseObject[@"data"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            dispatch_semaphore_signal(semaphore);
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        }];
    });
    // 执行循序2
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        [strongSelf getCatalogGoodsDataRequest:YES completedCall:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        // 执行顺序8
        hx_strongify(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf stopShimmer];
            strongSelf.collectionView.hidden = NO;
            [strongSelf.collectionView reloadData];
        });
    });
}
-(void)getCatalogGoodsDataRequest:(BOOL)isRefresh completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"provider_uid"] = self.provider_uid;
    parameters[@"catalog_id"] = @"25";
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"program/catalogGoods" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.collectionView.mj_header endRefreshing];
                strongSelf.pagenum = 1;

                [strongSelf.storeGoods removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXStoreGoods class] json:responseObject[@"data"]];
                [strongSelf.storeGoods addObjectsFromArray:arrt];
            }else{
                [strongSelf.collectionView.mj_footer endRefreshing];
                strongSelf.pagenum ++;

                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXStoreGoods class] json:responseObject[@"data"]];
                    [strongSelf.storeGoods addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
        completedCall();
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        completedCall();
        [strongSelf.collectionView.mj_header endRefreshing];
        [strongSelf.collectionView.mj_footer endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // CGFloat headerHeight = CGRectGetHeight(self.header.frame);
    CGFloat headerHeight = 180.f;
    CGFloat progress = scrollView.contentOffset.y;
    CGFloat gradientProgress = MIN(1, MAX(0, progress  / headerHeight));
    gradientProgress = gradientProgress * gradientProgress * gradientProgress * gradientProgress;
    if (gradientProgress < 0.1) {
        self.hbd_barStyle = UIBarStyleDefault;
        self.hbd_tintColor = UIColor.blackColor;
    } else {
        self.hbd_barStyle = UIBarStyleBlack;
        self.hbd_tintColor = UIColor.whiteColor;
    }
    self.hbd_barAlpha = gradientProgress;
    [self hbd_setNeedsUpdateNavigationBar];
}
#pragma mark -- 点击事件

#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.storeGoods.count;
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
    GXStoreGoods *storeGoods = self.storeGoods[indexPath.item];
    cell.storeGoods = storeGoods;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
    GXStoreGoods *storeGoods = self.storeGoods[indexPath.item];
    dvc.goods_id = storeGoods.goods_id;
    [self.navigationController pushViewController:dvc animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (HX_SCREEN_WIDTH-10*3)/2.0;
    CGFloat height = width+70.f;
    return CGSizeMake(width, height);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(HX_SCREEN_WIDTH, 160.f);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        GXStoreGoodsListHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:StoreGoodsListHeader forIndexPath:indexPath];
        hx_weakify(self);
        header.storeMsgCall = ^{
            hx_strongify(weakSelf);
            GXStoreMsgVC *mvc = [GXStoreMsgVC new];
            mvc.provider_uid = strongSelf.provider_uid;
            [strongSelf.navigationController pushViewController:mvc animated:YES];
        };
        header.storeInfo = self.storeInfo;
        return header;
    }
    return nil;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(10.f, 5.f, 10.f, 5.f);
}
@end
