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

static NSString *const PresellCell = @"PresellCell";
@interface GXPresellChildVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@end

@implementation GXPresellChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
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
    
//    hx_weakify(self);
//    [self.tableView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
//        [weakSelf startShimmer];
//        [weakSelf getMessageDataRequest:YES];
//    }];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getMessageDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getMessageDataRequest:NO];
    }];
}
#pragma mark -- 数据请求
-(void)getMessageDataRequest:(BOOL)isRefresh
{
    
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXPresellCell *cell = [tableView dequeueReusableCellWithIdentifier:PresellCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 110.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXPresellDetailVC *dvc = [GXPresellDetailVC new];
    dvc.goods_id = @"577";
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

@end
