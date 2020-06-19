//
//  GXPartnerIncomeVC.m
//  GX
//
//  Created by huaxin-01 on 2020/6/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXPartnerIncomeVC.h"
#import "GXPartnerIncomeCell.h"
#import "HXSearchBar.h"

static NSString *const PartnerIncomeCell = @"PartnerIncomeCell";
@interface GXPartnerIncomeVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
@end

@implementation GXPartnerIncomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavbar];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(void)setUpNavbar
{
    [self.navigationItem setTitle:nil];
    
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH - 88.f, 30.f)];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 15.f;
    searchBar.layer.masksToBounds = YES;
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入母婴店名称查询";
    self.searchBar = searchBar;
    self.navigationItem.titleView = searchBar;
    
    SPButton *filter = [SPButton buttonWithType:UIButtonTypeCustom];
    filter.hxn_size = CGSizeMake(40, 40);
    filter.titleLabel.font = [UIFont systemFontOfSize:9];
    [filter setImage:HXGetImage(@"时间筛选") forState:UIControlStateNormal];
    [filter addTarget:self action:@selector(filterClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filter];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXPartnerIncomeCell class]) bundle:nil] forCellReuseIdentifier:PartnerIncomeCell];
    
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)filterClicked
{
    HXLog(@"筛选");
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
//    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getCouponList" parameters:parameters success:^(id responseObject) {
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
    GXPartnerIncomeCell *cell = [tableView dequeueReusableCellWithIdentifier:PartnerIncomeCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 130.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
