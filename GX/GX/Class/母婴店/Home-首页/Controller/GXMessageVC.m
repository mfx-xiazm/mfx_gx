//
//  GXMessageVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMessageVC.h"
#import "GXMessageCell.h"
#import "GXMessage.h"
#import "GXOrderDetailVC.h"
#import "GXMyCouponVC.h"
#import "GXWebContentVC.h"

static NSString *const MessageCell = @"MessageCell";
@interface GXMessageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 列表 */
@property(nonatomic,strong) NSMutableArray *messages;
@end

@implementation GXMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"消息"];
    [self setUpTableView];
    [self setUpRefresh];
    [self startShimmer];
    [self getMessageDataRequest:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(NSMutableArray *)messages
{
    if (_messages == nil) {
        _messages = [NSMutableArray array];
    }
    return _messages;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXMessageCell class]) bundle:nil] forCellReuseIdentifier:MessageCell];
    
    hx_weakify(self);
    [self.tableView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
        [weakSelf startShimmer];
        [weakSelf getMessageDataRequest:YES];
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
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:[[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"3"]?@"program/getMessageData":@"admin/getMessageData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                
                [strongSelf.messages removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXMessage class] json:responseObject[@"data"]];
                [strongSelf.messages addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXMessage class] json:responseObject[@"data"]];
                    [strongSelf.messages addObjectsFromArray:arrt];
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
-(void)readMsgRequest:(NSString *)msg_id
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"msg_id"] = msg_id;
    [HXNetworkTool POST:HXRC_M_URL action:[[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"3"]?@"program/readMsg":@"admin/readMsg" parameters:parameters success:^(id responseObject) {
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GXMessage *msg = self.messages[indexPath.row];
    cell.msg = msg;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 70.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXMessage *msg = self.messages[indexPath.row];
    if ([msg.isRead isEqualToString:@"0"]) {
        msg.isRead = @"1";
        [self readMsgRequest:msg.msg_id];
        [tableView reloadData];
    }
    /** 0不关联 1订单详情 2退款订单详情 3优惠券发放 */
    if ([msg.ref_type isEqualToString:@"0"]) {
        GXWebContentVC *cvc = [GXWebContentVC new];
        cvc.navTitle = @"消息";
        cvc.isNeedRequest = NO;
        cvc.htmlContent = msg.msg_content;
        [self.navigationController pushViewController:cvc animated:YES];
    }else if ([msg.ref_type isEqualToString:@"1"]) {
        GXOrderDetailVC *dvc = [GXOrderDetailVC new];
        dvc.oid = msg.ref_id;
        [self.navigationController pushViewController:dvc animated:YES];
    }else if ([msg.ref_type isEqualToString:@"2"]) {
        GXOrderDetailVC *dvc = [GXOrderDetailVC new];
        dvc.refund_id = msg.ref_id;
        [self.navigationController pushViewController:dvc animated:YES];
    }else if ([msg.ref_type isEqualToString:@"3"]){
        GXMyCouponVC *cvc = [GXMyCouponVC new];
        cvc.selectIndex = 1;
        [self.navigationController pushViewController:cvc animated:YES];
    }
}

@end
