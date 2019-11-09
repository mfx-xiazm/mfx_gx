//
//  GXBrandDetailVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXBrandDetailVC.h"
#import "GXShopGoodsCell.h"
#import "GXBrandDetailHeader.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GXGoodsDetailVC.h"
#import "GXBrandDetail.h"
#import "GXBrandGoods.h"

static NSString *const ShopGoodsCell = @"ShopGoodsCell";
static NSString *const BrandDetailHeader = @"BrandDetailHeader";

@interface GXBrandDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/* 品牌基本信息 */
@property(nonatomic,strong) GXBrandDetail *brandDetail;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 列表 */
@property(nonatomic,strong) NSMutableArray *goods;
@end

@implementation GXBrandDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"品牌页"];
    [self setUpCollectionView];
    [self setUpRefresh];
    [self startShimmer];
    [self getBrandDetailRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(NSMutableArray *)goods
{
    if (_goods == nil) {
        _goods = [NSMutableArray array];
    }
    return _goods;
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
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXBrandDetailHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BrandDetailHeader];

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
-(void)getBrandDetailRequest
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 执行循序1
    hx_weakify(self);
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"brand_id"] = self.brand_id;
        
        [HXNetworkTool POST:HXRC_M_URL action:@"admin/brandDetail" parameters:parameters success:^(id responseObject) {
            if([[responseObject objectForKey:@"status"] integerValue] == 1) {
                strongSelf.brandDetail = [GXBrandDetail yy_modelWithDictionary:responseObject[@"data"]];
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
        [strongSelf getGoodsListDataRequest:YES completedCall:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        // 执行顺序10
        hx_strongify(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf stopShimmer];
            [strongSelf handleBrandDetailData];
        });
    });
    
}
-(void)getGoodsListDataRequest:(BOOL)isRefresh completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"brand_id"] = self.brand_id;//品牌id
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getBrandGoodList" parameters:parameters success:^(id responseObject) {
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
-(void)handleBrandDetailData
{
    self.collectionView.hidden = NO;
    
    [self.collectionView reloadData];
}
-(void)joinBrandRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"brand_id"] = self.brand_id;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/joinBrand" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [strongSelf getBrandDetailRequest];//成功刷新页面
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
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
    return  UIEdgeInsetsMake(5.f, 5.f, 10.f, 5.f);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString : UICollectionElementKindSectionHeader]){
        GXBrandDetailHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BrandDetailHeader forIndexPath:indexPath];
        headerView.brandDetail = self.brandDetail;
        hx_weakify(self);
        headerView.applyJoinCall = ^{
            hx_strongify(weakSelf);
            [strongSelf joinBrandRequest];
        };
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat height = 155.f;
    CGFloat descHeight = [self.brandDetail.brand_desc textHeightSize:CGSizeMake(HX_SCREEN_WIDTH-15*3, CGFLOAT_MAX) font:[UIFont systemFontOfSize:13] lineSpacing:5.f];
    height+= descHeight;
    /** 0未加盟 1审核中 2合作中 3审核驳回 4合作取消 */
    if ([self.brandDetail.apply_status isEqualToString:@"2"]) {// 没有加盟按钮
        return CGSizeMake(collectionView.frame.size.width, height+90.f);
    }else{// 有加盟按钮
        return CGSizeMake(collectionView.frame.size.width, height+120.f);
    }
}

@end
