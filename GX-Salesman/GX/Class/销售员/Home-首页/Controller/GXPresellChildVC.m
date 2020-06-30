//
//  GXPresellChildVC.m
//  GX
//
//  Created by huaxin-01 on 2020/6/17.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXPresellChildVC.h"
#import "GXPresellCell.h"
#import "GXPresellDetailVC.h"
#import "GXPreSales.h"
#import "OYCountDownManager.h"

static NSString *const PresellCell = @"PresellCell";
static NSString *const GXPresellSource1 = @"GXPresellSource1";
static NSString *const GXPresellSource2 = @"GXPresellSource2";

@interface GXPresellChildVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 列表 */
@property(nonatomic,strong) NSMutableArray *preSales;
@end

@implementation GXPresellChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpRefresh];
    [self startShimmer];
    // 启动倒计时管理
    [kCountDownManager start];
    // 增加倒计时源
    [kCountDownManager addSourceWithIdentifier:(self.seaType == 1)?GXPresellSource1:GXPresellSource2];
    [self getPreSaleDataRequest:YES];
}
-(NSMutableArray *)preSales
{
    if(!_preSales){
        _preSales = [NSMutableArray array];
    }
    return _preSales;
}
#pragma mark -- 视图相关
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXPresellCell class]) bundle:nil] forCellReuseIdentifier:PresellCell];
    
    hx_weakify(self);
    [self.tableView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
        [weakSelf startShimmer];
        [weakSelf getPreSaleDataRequest:YES];
    }];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
//    self.tableView.mj_header.automaticallyChangeAlpha = YES;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        hx_strongify(weakSelf);
//        [strongSelf.tableView.mj_footer resetNoMoreData];
//        [strongSelf getPreSaleDataRequest:YES];
//    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getPreSaleDataRequest:NO];
    }];
}
#pragma mark -- 数据请求
-(void)getPreSaleDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"seaType"] = @(self.seaType);
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"program/getPreSaleData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                
                [strongSelf.preSales removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXPreSales class] json:responseObject[@"data"]];
                [strongSelf.preSales addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXPreSales class] json:responseObject[@"data"]];
                    [strongSelf.preSales addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // 调用reload
                [kCountDownManager reloadSourceWithIdentifier:(self.seaType == 1)?GXPresellSource1:GXPresellSource2];
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
    return self.preSales.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXPresellCell *cell = [tableView dequeueReusableCellWithIdentifier:PresellCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GXPreSales *preSale = self.preSales[indexPath.row];
    preSale.countDownSource = (self.seaType == 1)?GXPresellSource1:GXPresellSource2;
    cell.preSale = preSale;
    [cell setCountDownZero:^(GXPreSales *preSale) {
        // 回调
        if (!preSale.timeOut) {
            HXLog(@"倒计时--%@--时间到了", preSale.goods_name);
        }
        // 标志
        preSale.timeOut = YES;
        [tableView reloadData];
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 110.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXPreSales *preSale = self.preSales[indexPath.row];
    GXPresellDetailVC *dvc = [GXPresellDetailVC new];
    dvc.pre_sale_id = preSale.presell_id;
    dvc.goods_id = preSale.goods_id;
    [self.navigationController pushViewController:dvc animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

#pragma mark -- JXPagingViewListViewDelegate

/**
 返回listView。如果是vc包裹的就是vc.view；如果是自定义view包裹的，就是自定义view自己。

 @return UIView
 */
- (UIView *)listView
{
    return self.view;
}

/**
 返回listView内部持有的UIScrollView或UITableView或UICollectionView
 主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView

 @return listView内部持有的UIScrollView或UITableView或UICollectionView
 */
- (UIScrollView *)listScrollView
{
    return self.tableView;
}

/**
 当listView内部持有的UIScrollView或UITableView或UICollectionView的代理方法`scrollViewDidScroll`回调时，需要调用该代理方法传入的callback

 @param callback `scrollViewDidScroll`回调时调用的callback
 */
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *scrollView))callback
{
    self.scrollCallback = callback;
}

-(void)dealloc
{
    HXLog(@"预售列表销毁");
    [kCountDownManager removeSourceWithIdentifier:(self.seaType == 1)?GXPresellSource1:GXPresellSource2];
    [kCountDownManager invalidate];
}
@end
