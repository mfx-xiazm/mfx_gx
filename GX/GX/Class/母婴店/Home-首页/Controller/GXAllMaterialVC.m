//
//  GXAllMaterialVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXAllMaterialVC.h"
#import "GXGoodsMaterialCell.h"
#import "GXGoodsMaterialLayout.h"
#import "HXSearchBar.h"
#import "GXGoodsDetailVC.h"

@interface GXAllMaterialVC ()<UITableViewDelegate,UITableViewDataSource,GXGoodsMaterialCellDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 布局数组 */
@property (nonatomic,strong) NSMutableArray *layoutsArr;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
@end

@implementation GXAllMaterialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpRefresh];
    if (!self.isSearch) {
        [self startShimmer];
        [self getMaterialListDataRequest:YES];
    }
}
-(NSMutableArray *)layoutsArr
{
    if (!_layoutsArr) {
        _layoutsArr = [NSMutableArray array];
    }
    return _layoutsArr;
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    if (self.isSearch) {
        [self.navigationItem setTitle:nil];

        HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH - 70.f, 30.f)];
        searchBar.backgroundColor = [UIColor whiteColor];
        searchBar.layer.cornerRadius = 6;
        searchBar.layer.masksToBounds = YES;
        searchBar.delegate = self;
        self.searchBar = searchBar;
        self.navigationItem.titleView = searchBar;
    }else{
        [self.navigationItem setTitle:@"全部素材"];
    }
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
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getMaterialListDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getMaterialListDataRequest:NO];
    }];
}
-(void)getMaterialListDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.goods_id && self.goods_id.length) {
        parameters[@"goods_id"] = self.goods_id;//商品id
    }else{
        parameters[@"material_title"] = @"";//货素材标题搜索 没有则不传或者传""
        parameters[@"top"] = @(1);//为1表示筛选全部 为2表示筛选购买过 为3表示筛选转发过 根据素材名称搜索时没有该字段则不传或者传""
        parameters[@"control"] = @"2";//为1表示筛选控区控价 为2表示筛选全部 没有该字段则不传或者传""
        parameters[@"catalog_id"] = (self.catalog_id && self.catalog_id.length)?self.catalog_id:@"";//根据商品分类筛选卖货素材
        parameters[@"advertise_id"] = @"";//根据宣传分类筛选卖货素材
        parameters[@"plan_id"] = @"";//根据卖货方案分类id筛选卖货素材
    }
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:(self.goods_id && self.goods_id.length)?@"admin/getGoodMaterial":@"admin/materialList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                
                [strongSelf.layoutsArr removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXGoodsMaterial class] json:responseObject[@"data"]];
                for (GXGoodsMaterial *material in arrt) {
                    GXGoodsMaterialLayout *layout = [[GXGoodsMaterialLayout alloc] initWithModel:material];
                    [strongSelf.layoutsArr addObject:layout];
                }
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXGoodsMaterial class] json:responseObject[@"data"]];
                    for (GXGoodsMaterial *material in arrt) {
                        GXGoodsMaterialLayout *layout = [[GXGoodsMaterialLayout alloc] initWithModel:material];
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
#pragma mark -- UITextField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self getMaterialListDataRequest:YES];
    return YES;
}
#pragma mark -- TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.layoutsArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXGoodsMaterialLayout *layout = self.layoutsArr[indexPath.row];
    return layout.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXGoodsMaterialCell * cell = [GXGoodsMaterialCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.targetVc = self;
    GXGoodsMaterialLayout *layout = self.layoutsArr[indexPath.row];
    cell.materialLayout = layout;
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma arguments/** 评价 */
/** 点击了全文/收回 */
- (void)didClickMoreLessInCell:(GXGoodsMaterialCell *)Cell
{
    GXGoodsMaterialLayout *layout = Cell.materialLayout;
    layout.material.isOpening = !layout.material.isOpening;
    
    [layout resetLayout];
    [self.tableView reloadData];
}
/** 查看商品 */
- (void)didClickGoodsInCell:(GXGoodsMaterialCell *)Cell
{
    GXGoodsMaterial *material = Cell.materialLayout.material;
    GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
    dvc.goods_id = material.goods_id;
    [self.navigationController pushViewController:dvc animated:YES];
}
/** 分享 */
- (void)didClickShareInCell:(GXGoodsMaterialCell *)Cell
{
    HXLog(@"一键分享");
}
@end
