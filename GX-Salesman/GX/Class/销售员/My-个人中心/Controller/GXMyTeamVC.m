//
//  GXMyTeamVC.m
//  GX
//
//  Created by huaxin-01 on 2020/6/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXMyTeamVC.h"
#import "GXMyTeamCell.h"
#import "GXMyTeamHeader.h"

static NSString *const MyTeamCell = @"MyTeamCell";
@interface GXMyTeamVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GXMyTeamHeader *header;
@end

@implementation GXMyTeamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavbar];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 260.f);
}
-(GXMyTeamHeader *)header
{
    if (!_header) {
        _header = [GXMyTeamHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 260.f);
    }
    return _header;
}
-(void)setUpNavbar
{
    self.hbd_barAlpha = 0.0;
    
    [self.navigationItem setTitle:@"我的团队"];
    
    SPButton *set = [SPButton buttonWithType:UIButtonTypeCustom];
    set.hxn_size = CGSizeMake(40, 40);
    set.titleLabel.font = [UIFont systemFontOfSize:9];
    [set setImage:HXGetImage(@"筛选白") forState:UIControlStateNormal];
    [set addTarget:self action:@selector(filterClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:set];
}
-(void)setUpTableView
{
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXMyTeamCell class]) bundle:nil] forCellReuseIdentifier:MyTeamCell];
    
    self.tableView.tableHeaderView = self.header;
//    hx_weakify(self);
//    [self.tableView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
//        [weakSelf startShimmer];
//        [weakSelf getCouponListRequest:YES];
//    }];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
//    hx_weakify(self);
//    self.tableView.mj_header.automaticallyChangeAlpha = YES;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        hx_strongify(weakSelf);
//        [strongSelf.tableView.mj_footer resetNoMoreData];
//        [strongSelf getCouponListRequest:YES];
//    }];
//    //追加尾部刷新
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        hx_strongify(weakSelf);
//        [strongSelf getCouponListRequest:NO];
//    }];
}
#pragma mark -- 点击事件
-(void)filterClicked
{
    HXLog(@"筛选");
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // CGFloat headerHeight = CGRectGetHeight(self.header.frame);
    CGFloat headerHeight = 200.f;
    CGFloat progress = scrollView.contentOffset.y;
    //HXLog(@"便宜量-%.2f",progress);
    CGFloat gradientProgress = MIN(1, MAX(0, progress  / headerHeight));
    gradientProgress = gradientProgress * gradientProgress * gradientProgress * gradientProgress;
    self.hbd_barAlpha = gradientProgress;
    [self hbd_setNeedsUpdateNavigationBar];
    
    CGRect frame = self.header.imageViewFrame;
    frame.size.height -= progress;
    frame.origin.y = progress;
    self.header.imageView.frame = frame;
}
#pragma mark -- 数据请求
//-(void)getCouponListRequest:(BOOL)isRefresh
//{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"seaType"] = @(self.seaType);
//    if (isRefresh) {
//        parameters[@"page"] = @(1);//第几页
//    }else{
//        NSInteger page = self.pagenum+1;
//        parameters[@"page"] = @(page);//第几页
//    }
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"program/getCouponList" parameters:parameters success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        [strongSelf stopShimmer];
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            if (isRefresh) {
//                [strongSelf.tableView.mj_header endRefreshing];
//                strongSelf.pagenum = 1;
//
//                [strongSelf.coupons removeAllObjects];
//                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXMyCoupon class] json:responseObject[@"data"]];
//                [strongSelf.coupons addObjectsFromArray:arrt];
//            }else{
//                [strongSelf.tableView.mj_footer endRefreshing];
//                strongSelf.pagenum ++;
//
//                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
//                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXMyCoupon class] json:responseObject[@"data"]];
//                    [strongSelf.coupons addObjectsFromArray:arrt];
//                }else{// 提示没有更多数据
//                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//                }
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                strongSelf.tableView.hidden = NO;
//                [strongSelf.tableView reloadData];
//            });
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        hx_strongify(weakSelf);
//        [strongSelf stopShimmer];
//        [strongSelf.tableView.mj_header endRefreshing];
//        [strongSelf.tableView.mj_footer endRefreshing];
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
//}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXMyTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:MyTeamCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 90.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
