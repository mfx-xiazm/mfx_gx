//
//  GXAllCommentVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXAllCommentVC.h"
#import "GXAllCommentHeader.h"
#import "GXGoodsCommentLayout.h"
#import "GXGoodsCommentCell.h"

@interface GXAllCommentVC ()<UITableViewDelegate,UITableViewDataSource,GXGoodsCommentCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) GXAllCommentHeader *header;
/** 布局数组 */
@property (nonatomic,strong) NSMutableArray *layoutsArr;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
@end

@implementation GXAllCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"全部评价"];
    [self setUpTableView];
    [self setUpRefresh];
    [self startShimmer];
    [self getCommentListDataRequest:YES];
}
-(NSMutableArray *)layoutsArr
{
    if (!_layoutsArr) {
        _layoutsArr = [NSMutableArray array];
    }
    return _layoutsArr;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 200);
}
#pragma mark -- 视图相关
-(GXAllCommentHeader *)header
{
    if (_header == nil) {
        _header = [GXAllCommentHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 200);
        _header.goodsDetail = self.goodsDetail;
    }
    return _header;
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
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableHeaderView = self.header;
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getCommentListDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getCommentListDataRequest:NO];
    }];
}
-(void)getCommentListDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goods_id;//商品id
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getGoodEvaList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;

                [strongSelf.layoutsArr removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXGoodsComment class] json:responseObject[@"data"]];
                for (GXGoodsComment *comment in arrt) {
                    GXGoodsCommentLayout *layout = [[GXGoodsCommentLayout alloc] initWithModel:comment];
                    [strongSelf.layoutsArr addObject:layout];
                }
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;

                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXGoodsComment class] json:responseObject[@"data"]];
                    for (GXGoodsComment *comment in arrt) {
                        GXGoodsCommentLayout *layout = [[GXGoodsCommentLayout alloc] initWithModel:comment];
                        [strongSelf.layoutsArr addObject:layout];
                    }
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
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
#pragma mark -- TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.layoutsArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXGoodsCommentLayout *layout = self.layoutsArr[indexPath.row];
    return layout.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXGoodsCommentCell * cell = [GXGoodsCommentCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.targetVc = self;
    GXGoodsCommentLayout *layout = self.layoutsArr[indexPath.row];
    cell.commentLayout = layout;
    cell.delegate = self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [UILabel new];
    label.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 30.f);
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    label.text = [NSString stringWithFormat:@"   全部评价"];
    
    return label;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -- GXGoodsCommentCellDelegate
/** 点击了全文/收回 */
- (void)didClickMoreLessInCommentCell:(GXGoodsCommentCell *)Cell
{
    GXGoodsCommentLayout *layout = Cell.commentLayout;
    layout.comment.isOpening = !layout.comment.isOpening;
    
    [layout resetLayout];
    [self.tableView reloadData];
}
@end
