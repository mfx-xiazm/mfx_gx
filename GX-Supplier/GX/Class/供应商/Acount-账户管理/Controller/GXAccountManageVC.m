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
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "GXOrderDetailVC.h"
#import "GXMineData.h"
#import "GXMySetVC.h"
#import "GXMyHeader.h"
#import "GXBalanceNoteVC.h"
#import "GXCashNoteDetailVC.h"

static NSString *const AccountManageCell = @"AccountManageCell";
@interface GXAccountManageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GXMyHeader *header;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 订单列表 */
@property(nonatomic,strong) NSMutableArray *logs;
/* 账户信息 */
@property(nonatomic,strong) NSDictionary *accountData;
/* 提现天数 */
@property(nonatomic,copy) NSString *cashable_day;
/* 个人信息 */
@property(nonatomic,strong) GXMineData *mineData;
/* 设置 */
@property (nonatomic, strong) SPButton *setBtn;
@end

@implementation GXAccountManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavbar];
    [self setUpTableView];
    [self getMemberRequest];
    [self getFinanceLogRequest:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserBalanceRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 300);
}
-(NSMutableArray *)logs
{
    if (_logs == nil) {
        _logs = [NSMutableArray array];
    }
    return _logs;
}
-(GXMyHeader *)header
{
    if (!_header) {
        _header = [GXMyHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 300);
        hx_weakify(self);
        _header.headerBtnClicked = ^(NSInteger index) {
            hx_strongify(weakSelf);
            if (index == 0) {
                [strongSelf cashNoticeClicked:nil];
            }else if (index == 1) {
                GXBalanceNoteVC *nvc = [GXBalanceNoteVC new];
                [strongSelf.navigationController pushViewController:nvc animated:YES];
            }else{
                [strongSelf cashBtnClicked:nil];
            }
        };
    }
    return _header;
}
-(void)setUpNavbar
{
    self.hbd_barAlpha = 0.0;
    
    SPButton *set = [SPButton buttonWithType:UIButtonTypeCustom];
    set.hxn_size = CGSizeMake(40, 40);
    set.titleLabel.font = [UIFont systemFontOfSize:9];
    [set setImage:HXGetImage(@"设置") forState:UIControlStateNormal];
    [set addTarget:self action:@selector(setClicked) forControlEvents:UIControlEventTouchUpInside];
    self.setBtn = set;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:set];
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 85.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXAccountManageCell class]) bundle:nil] forCellReuseIdentifier:AccountManageCell];
    
    self.tableView.tableHeaderView = self.header;
}
#pragma mark -- 数据请求
-(void)getMemberRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"index/getMineData" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.mineData = [GXMineData yy_modelWithDictionary:responseObject[@"data"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getFinanceLogRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isRefresh) {
        [self getUserBalanceRequest];
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
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.logs removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXFinanceLog class] json:responseObject[@"data"]];
                [strongSelf.logs addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;

                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXFinanceLog class] json:responseObject[@"data"]];
                    [strongSelf.logs addObjectsFromArray:arrt];
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
-(void)getUserBalanceRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:[[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"2"]?@"index/getUserBalance":@"program/getUserBalance" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.accountData = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
            if ([[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"2"]) {
                strongSelf.cashable_day = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"provider_cashable_day"]];
            }else{
                strongSelf.cashable_day = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"saleman_cashable_day"]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.header.balance.text = [NSString stringWithFormat:@"%@元",responseObject[@"data"][@"balance"]];
                strongSelf.header.cash_balance.text = [NSString stringWithFormat:@"%@元",responseObject[@"data"][@"cashable_balance"]];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 点击事件
-(void)setClicked
{
    GXMySetVC *mvc = [GXMySetVC new];
    mvc.mineData = self.mineData;
    [self.navigationController pushViewController:mvc animated:YES];
}
- (void)cashBtnClicked:(UIButton *)sender {
    GXCashVC *cvc = [GXCashVC new];
    cvc.cashable = [NSString stringWithFormat:@"%@",self.accountData[@"cashable_balance"]];
    hx_weakify(self);
    cvc.cashCall = ^{
        hx_strongify(weakSelf);
        [strongSelf getFinanceLogRequest:YES];
    };
    [self.navigationController pushViewController:cvc animated:YES];
}
-(void)cashNoticeClicked:(UIButton *)sender
{
    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提现说明" message:[NSString stringWithFormat:@"订单确认收货后，%@天后才能申请提现",self.cashable_day] constantWidth:HX_SCREEN_WIDTH - 50*2];
    hx_weakify(self);
    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"我知道了" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
    }];
    okButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
    [alert addAction:okButton];
    self.zh_popupController = [[zhPopupController alloc] init];
    [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
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
    if (log.finance_log_type <= 5 || log.finance_log_type >= 30) {
        return 35.f+60.f+10.f;
    }else{
        return 60.f+10.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXFinanceLog *log = self.logs[indexPath.row];

    if (log.finance_log_type <= 5 || (log.finance_log_type >= 30 && log.finance_log_type <= 32) || log.finance_log_type >= 40) {
        GXOrderDetailVC *dvc = [GXOrderDetailVC new];
        dvc.oid = log.orderInfo.oid;
        [self.navigationController pushViewController:dvc animated:YES];
    }else{
        if ([log.ref_id isEqualToString:@"0"]) {
            return;
        }
        GXCashNoteDetailVC *nvc = [GXCashNoteDetailVC new];
        nvc.finance_apply_id = log.ref_id;
        [self.navigationController pushViewController:nvc animated:YES];
    }
}
@end
