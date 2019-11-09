//
//  GXPartnerDataVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXPartnerDataVC.h"
#import "GXPartnerDataCell.h"
#import "GXPartnerDataSectionHeader.h"
#import "GXMyBusiness.h"

static NSString *const PartnerDataCell = @"PartnerDataCell";
@interface GXPartnerDataVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 我的生意 */
@property(nonatomic,strong) GXMyBusiness *myBusiness;
@end

@implementation GXPartnerDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"门店经营数据报告"];
    [self setUpTableView];
    [self startShimmer];
    [self getMyBusinessRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXPartnerDataCell class]) bundle:nil] forCellReuseIdentifier:PartnerDataCell];
}
-(void)getMyBusinessRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"seaType"] = @(2);
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getMyBusiness" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.myBusiness = [GXMyBusiness yy_modelWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return self.myBusiness.brand.count;
    }else{
        return self.myBusiness.catalog.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXPartnerDataCell *cell = [tableView dequeueReusableCellWithIdentifier:PartnerDataCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleView.hidden = indexPath.section?NO:YES;
    if (indexPath.section == 0) {
        cell.myBusiness = self.myBusiness;
    }else if (indexPath.section == 1) {
        GXMyBrandBusiness *brandBusiness = self.myBusiness.brand[indexPath.row];
        cell.brandBusiness = brandBusiness;
    }else{
        GXMyCataBusiness *cateBusiness = self.myBusiness.catalog[indexPath.row];
        cell.cateBusiness = cateBusiness;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return indexPath.section?130.f:90.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GXPartnerDataSectionHeader *header = [GXPartnerDataSectionHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44.f);
    if (section == 0) {
        header.titleLabel.text = @"数据概览";
    }else if (section == 1) {
        header.titleLabel.text = @"品牌数据";
    }else{
        header.titleLabel.text = @"类目数据";
    }
    header.moreTitle.hidden = NO;
    
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
