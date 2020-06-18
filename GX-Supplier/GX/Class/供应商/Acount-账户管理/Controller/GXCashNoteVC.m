//
//  GXCashNoteVC.m
//  GX
//
//  Created by huaxin-01 on 2020/6/18.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXCashNoteVC.h"
#import "GXCashNoteCell.h"

static NSString *const CashNoteCell = @"CashNoteCell";
@interface GXCashNoteVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GXCashNoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavbar];
    [self setUpTableView];
}
-(void)setUpNavbar
{
    [self.navigationItem setTitle:@"提现记录"];

    SPButton *set = [SPButton buttonWithType:UIButtonTypeCustom];
    set.hxn_size = CGSizeMake(40, 40);
    set.titleLabel.font = [UIFont systemFontOfSize:9];
    [set setImage:HXGetImage(@"筛选白") forState:UIControlStateNormal];
    [set addTarget:self action:@selector(noteFliterClicked) forControlEvents:UIControlEventTouchUpInside];
    
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXCashNoteCell class]) bundle:nil] forCellReuseIdentifier:CashNoteCell];
}
-(void)noteFliterClicked
{
    HXLog(@"筛选");
}
#pragma mark -- 数据请求
-(void)getFinanceLogRequest:(BOOL)isRefresh
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    if (isRefresh) {
//        parameters[@"page"] = @(1);//第几页
//    }else{
//        NSInteger page = self.pagenum+1;
//        parameters[@"page"] = @(page);//第几页
//    }
//
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:[[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"2"]?@"index/getFinanceLog":@"program/getFinanceLog" parameters:parameters success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        [strongSelf stopShimmer];
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            if (isRefresh) {
//                [strongSelf.tableView.mj_header endRefreshing];
//                strongSelf.pagenum = 1;
//                [strongSelf.logs removeAllObjects];
//                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXFinanceLog class] json:responseObject[@"data"]];
//                [strongSelf.logs addObjectsFromArray:arrt];
//            }else{
//                [strongSelf.tableView.mj_footer endRefreshing];
//                strongSelf.pagenum ++;
//
//                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
//                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXFinanceLog class] json:responseObject[@"data"]];
//                    [strongSelf.logs addObjectsFromArray:arrt];
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
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXCashNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:CashNoteCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
