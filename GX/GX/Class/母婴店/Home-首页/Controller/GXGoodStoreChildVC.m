//
//  GXGoodStoreChildVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXGoodStoreChildVC.h"
#import "GXStoreCell.h"
#import "GXStoreGoodsListVC.h"
#import "GXStoreMsgVC.h"
#import "GXStore.h"
#import "HXSearchBar.h"
#import "GXStoreHeader.h"
#import "GXGoodsFilterView.h"
#import <zhPopupController.h>
#import "GXCatalogItem.h"

static NSString *const StoreCell = @"StoreCell";
@interface GXGoodStoreChildVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头部 */
@property (nonatomic, strong) GXStoreHeader *header;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 列表 */
@property(nonatomic,strong) NSMutableArray *stores;
/* 分类 */
@property(nonatomic,strong) NSArray *cateItems;
/* 分类筛选视图 */
@property(nonatomic,strong) GXGoodsFilterView *fliterView;
@end

@implementation GXGoodStoreChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpRefresh];
    [self getShopCateRequest];
    [self getCatalogShopRequest:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.view.hxn_width = HX_SCREEN_WIDTH;
    self.header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44.f);
}
-(NSMutableArray *)stores
{
    if (_stores == nil) {
        _stores = [NSMutableArray array];
    }
    return _stores;
}
-(GXGoodsFilterView *)fliterView
{
    if (_fliterView == nil) {
        _fliterView = [GXGoodsFilterView loadXibView];
        _fliterView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-80, HX_SCREEN_HEIGHT);
    }
    return _fliterView;
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH - 88.f, 30.f)];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 15.f;
    searchBar.layer.masksToBounds = YES;
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入店铺名称查询";
    self.searchBar = searchBar;
    self.navigationItem.titleView = searchBar;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(filterClicked) nomalImage:HXGetImage(@"筛选白") higeLightedImage:HXGetImage(@"筛选白") imageEdgeInsets:UIEdgeInsetsZero];
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.rowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXStoreCell class]) bundle:nil] forCellReuseIdentifier:StoreCell];
    
    GXStoreHeader *header = [GXStoreHeader loadXibView];
    header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 44.f);
    self.header = header;
    self.tableView.tableHeaderView = header;
    
    hx_weakify(self);
    [self.tableView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
        [weakSelf startShimmer];
        [weakSelf getCatalogShopRequest:YES];
    }];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getCatalogShopRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getCatalogShopRequest:NO];
    }];
}
#pragma mark -- 点击事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self getCatalogShopRequest:YES];
    return YES;
}
-(void)filterClicked
{
    if (!self.cateItems) {
        return;
    }
    
    self.fliterView.dataType = 4;
    self.fliterView.logItemId = self.catalog_id;
    self.fliterView.brandItemId = self.brand_id;
    self.fliterView.dataSouce = self.cateItems;
    hx_weakify(self);
    self.fliterView.filterCall = ^(NSString *logItemId, NSString  *brandItemId) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        strongSelf.catalog_id = logItemId;
        strongSelf.brand_id = brandItemId;
        [strongSelf getCatalogShopRequest:YES];
    };
    
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeRight;
    [self.zh_popupController presentContentView:self.fliterView duration:0.25 springAnimated:NO];
}
#pragma mark -- 数据请求
-(void)getShopCateRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/selectShop" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.cateItems = [NSArray yy_modelArrayWithClass:[GXCatalogItem class] json:responseObject[@"data"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getCatalogShopRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"catalog_id"] = self.catalog_id;
    parameters[@"brand_id"] = self.brand_id;
    parameters[@"goods_name"] = self.searchBar.text;
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getCatalogShop" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                
                [strongSelf.stores removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXStore class] json:responseObject[@"data"]];
                [strongSelf.stores addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXStore class] json:responseObject[@"data"]];
                    [strongSelf.stores addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.tableView.hidden = NO;
                [strongSelf.tableView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stores.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:StoreCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GXStore *store = self.stores[indexPath.row];
    cell.store = store;
    hx_weakify(self);
    cell.storeHandleCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        if (index == 1) {
            GXStoreMsgVC *mvc = [GXStoreMsgVC new];
            mvc.provider_uid = store.uid;
            [strongSelf.navigationController pushViewController:mvc animated:YES];
        }else{
            GXStoreGoodsListVC *lvc = [GXStoreGoodsListVC new];
            lvc.provider_uid = store.uid;
            [strongSelf.navigationController pushViewController:lvc animated:YES];
        }
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    GXStore *store = self.stores[indexPath.row];
    if (store.coupons && store.coupons.count) {
        return 5.f + 60.f + 60.f + (HX_SCREEN_WIDTH-10.f*6)/3.0 + 50.f + 5.f;
    }else{
        return 5.f + 60.f + (HX_SCREEN_WIDTH-10.f*6)/3.0 + 50.f + 5.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXStore *store = self.stores[indexPath.row];
    GXStoreGoodsListVC *lvc = [GXStoreGoodsListVC new];
    lvc.provider_uid = store.uid;
    [self.navigationController pushViewController:lvc animated:YES];
}

@end
