//
//  GXRegionalVC.m
//  GX
//
//  Created by 夏增明 on 2019/9/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXRegionalVC.h"
#import "GXRegionalCell.h"
#import "GXRegionalHeader.h"
#import "GXWebContentVC.h"
#import "GXBrandPartnerVC.h"
#import "GXBrandDetailVC.h"
#import "GXSaleMaterialVC.h"
#import "GXTryApplyVC.h"
#import "GXPartnerDataVC.h"
#import "GXRegional.h"
#import "GXGoodBrand.h"
#import "GXGoodsDetailVC.h"

static NSString *const RegionalCell = @"RegionalCell";

@interface GXRegionalVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) GXRegionalHeader *header;
/* 控区控价 */
@property(nonatomic,strong) GXRegional *regional;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 列表 */
@property(nonatomic,strong) NSMutableArray *brands;
@end

@implementation GXRegionalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"控区控价"];
    [self setUpTableView];
    [self setUpRefresh];
    [self startShimmer];
    [self getRegionalControlDataRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 265.f);
}
-(NSMutableArray *)brands
{
    if (_brands == nil) {
        _brands = [NSMutableArray array];
    }
    return _brands;
}
-(GXRegionalHeader *)header
{
    if (_header == nil) {
        _header = [GXRegionalHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 265.f);
        hx_weakify(self);
        _header.regionalClickedCall = ^(NSInteger type, NSInteger index) {
            hx_strongify(weakSelf);
            if (type == 1) {
                GXRegionalBanner *banner = strongSelf.regional.adv[index];
                /** 1仅图片 2链接内容 3html富文本内容 4产品详情 */
                if ([banner.adv_type isEqualToString:@"1"]) {
                    HXLog(@"仅图片");
                }else if ([banner.adv_type isEqualToString:@"2"]) {
                    GXWebContentVC *cvc = [GXWebContentVC new];
                    cvc.navTitle = banner.adv_name;
                    cvc.isNeedRequest = NO;
                    cvc.url = banner.adv_content;
                    [strongSelf.navigationController pushViewController:cvc animated:YES];
                }else if ([banner.adv_type isEqualToString:@"3"]) {
                    GXWebContentVC *cvc = [GXWebContentVC new];
                    cvc.navTitle = banner.adv_name;
                    cvc.isNeedRequest = NO;
                    cvc.htmlContent = banner.adv_content;
                    [strongSelf.navigationController pushViewController:cvc animated:YES];
                }else{
                    GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
                    dvc.goods_id = banner.adv_content;
                    [strongSelf.navigationController pushViewController:dvc animated:YES];
                }
            }else if (type == 2){
                GXRegionalNotice *notice = strongSelf.regional.notice[index];
                GXWebContentVC *wvc = [GXWebContentVC new];
                wvc.navTitle = @"公告详情";
                wvc.isNeedRequest = YES;
                wvc.requestType = 3;
                wvc.notice_id = notice.notice_id;
                [strongSelf.navigationController pushViewController:wvc animated:YES];
            }else{
                if (index == 1) {
                    GXBrandPartnerVC *pvc = [GXBrandPartnerVC new];
                    [strongSelf.navigationController pushViewController:pvc animated:YES];
                }else if (index == 2){
                    GXPartnerDataVC *dvc = [GXPartnerDataVC new];
                    [strongSelf.navigationController pushViewController:dvc animated:YES];
                }else{
                    GXSaleMaterialVC *mvc = [GXSaleMaterialVC new];
                    [strongSelf.navigationController pushViewController:mvc animated:YES];
                }
            }
        };
    }
    return _header;
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
    self.tableView.backgroundColor = HXGlobalBg;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXRegionalCell class]) bundle:nil] forCellReuseIdentifier:RegionalCell];
    
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
        [strongSelf getHotBrandDataRequest:YES completedCall:^{
            [strongSelf.tableView reloadData];
        }];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getHotBrandDataRequest:NO completedCall:^{
            [strongSelf.tableView reloadData];
        }];
    }];
}
#pragma mark -- 接口请求
-(void)getRegionalControlDataRequest
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 执行循序1
    hx_weakify(self);
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        
        [HXNetworkTool POST:HXRC_M_URL action:@"admin/controlData" parameters:@{} success:^(id responseObject) {
            if([[responseObject objectForKey:@"status"] integerValue] == 1) {
                strongSelf.regional = [GXRegional yy_modelWithDictionary:responseObject[@"data"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    // 执行循序2
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        [strongSelf getHotBrandDataRequest:YES completedCall:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        // 执行顺序10
        hx_strongify(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf stopShimmer];
            [strongSelf handleRegionalData];
        });
    });
}
-(void)getHotBrandDataRequest:(BOOL)isRefresh completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getHotBrand" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                
                [strongSelf.brands removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXGoodBrand class] json:responseObject[@"data"]];
                [strongSelf.brands addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXGoodBrand class] json:responseObject[@"data"]];
                    [strongSelf.brands addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
        if (completedCall) {
            completedCall();
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        if (completedCall) {
            completedCall();
        }
    }];
}
-(void)handleRegionalData
{
    self.tableView.hidden = NO;
    
    self.header.regional = self.regional;
    
    [self.tableView reloadData];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
        return self.brands.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXRegionalCell *cell = [tableView dequeueReusableCellWithIdentifier:RegionalCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section) {
        GXGoodBrand *brand = self.brands[indexPath.row];
        cell.brand = brand;
    }else{
        if (indexPath.row) {
            GXRegionalTry *rtry = self.regional.try_cover;
            cell.rtry = rtry;
        }else{
            GXRegionalWeekNewer *week = self.regional.week_newer;
            cell.week = week;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    if (indexPath.section == 0) {
        return 110.f;
    }else{
        return 260.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1f;
    }else{
        return 44.f;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section) {
        UIImageView *image = [[UIImageView alloc] init];
        image.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44.f);
        image.backgroundColor = HXGlobalBg;
        image.contentMode = UIViewContentModeCenter;
        image.image = HXGetImage(@"热门品牌");
        return image;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//本周上新
            GXBrandDetailVC *dvc = [GXBrandDetailVC new];
            dvc.brand_id = self.regional.week_newer.brand_id;
            [self.navigationController pushViewController:dvc animated:YES];
        }else{//试用装
            GXTryApplyVC *avc = [GXTryApplyVC new];
            avc.try_cover = self.regional.try_cover.try_cover;
            [self.navigationController pushViewController:avc animated:YES];
        }
    }else{//热门品牌
        GXGoodBrand *brand = self.brands[indexPath.row];
        GXBrandDetailVC *dvc = [GXBrandDetailVC new];
        dvc.brand_id = brand.brand_id;
        [self.navigationController pushViewController:dvc animated:YES];
    }
}
@end
