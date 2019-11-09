//
//  GXAccountManageVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/8.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXAccountManageVC.h"
#import "GXAccountManageCell.h"
#import "GXCashVC.h"
#import "GXFinanceLog.h"

static NSString *const AccountManageCell = @"AccountManageCell";
@interface GXAccountManageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *content_scroll;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *cash_balance;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 订单列表 */
@property(nonatomic,strong) NSMutableArray *logs;
/* 账户信息 */
@property(nonatomic,strong) NSDictionary *accountData;
@end

@implementation GXAccountManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpRefresh];
    [self getFinanceLogRequest:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserBalanceRequest];
}
-(NSMutableArray *)logs
{
    if (_logs == nil) {
        _logs = [NSMutableArray array];
    }
    return _logs;
}
-(void)setUpTableView
{
    self.tableView.scrollEnabled = NO;
    self.tableView.estimatedRowHeight = 85.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXAccountManageCell class]) bundle:nil] forCellReuseIdentifier:AccountManageCell];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.content_scroll.mj_header.automaticallyChangeAlpha = YES;
    self.content_scroll.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.content_scroll.mj_footer resetNoMoreData];
        [strongSelf getFinanceLogRequest:YES];
    }];
    //追加尾部刷新
    self.content_scroll.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getFinanceLogRequest:NO];
    }];
}
#pragma mark -- 数据请求
-(void)getFinanceLogRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:[[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"2"]?@"index/getFinanceLog":@"program/getFinanceLog" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.content_scroll.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.logs removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXFinanceLog class] json:responseObject[@"data"]];
                [strongSelf.logs addObjectsFromArray:arrt];
            }else{
                [strongSelf.content_scroll.mj_footer endRefreshing];
                strongSelf.pagenum ++;

                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXFinanceLog class] json:responseObject[@"data"]];
                    [strongSelf.logs addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.content_scroll.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.content_scroll.hidden = NO;
                [strongSelf.tableView reloadData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    strongSelf.tableViewHeight.constant = strongSelf.tableView.contentSize.height + 30.f;
                });
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [strongSelf.content_scroll.mj_header endRefreshing];
        [strongSelf.content_scroll.mj_footer endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getUserBalanceRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:[[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"2"]?@"index/getUserBalance":@"program/getUserBalance" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.accountData = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.balance.text = [NSString stringWithFormat:@"%@元",responseObject[@"data"][@"balance"]];
                strongSelf.cash_balance.text = [NSString stringWithFormat:@"%@元",responseObject[@"data"][@"cashable_balance"]];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 点击事件
- (IBAction)cashBtnClicked:(UIButton *)sender {
    GXCashVC *cvc = [GXCashVC new];
    cvc.cashable = [NSString stringWithFormat:@"%@",self.accountData[@"cashable_balance"]];
    [self.navigationController pushViewController:cvc animated:YES];
}

#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.logs.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXAccountManageCell *cell = [tableView dequeueReusableCellWithIdentifier:AccountManageCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GXFinanceLog *log = self.logs[indexPath.row];
    cell.log = log;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXFinanceLog *log = self.logs[indexPath.row];
    if (log.finance_log_type <= 5) {
        return 35.f+60.f+10.f;
    }else{
        return 60.f+10.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
