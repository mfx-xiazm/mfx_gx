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
#import "GXMyTeam.h"
#import "GXMyTeamCount.h"
#import "ZJPickerView.h"

static NSString *const MyTeamCell = @"MyTeamCell";
@interface GXMyTeamVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GXMyTeamHeader *header;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 列表 */
@property(nonatomic,strong) NSMutableArray *teams;
/** 团队数量  */
@property (nonatomic, strong) GXMyTeamCount *teamCount;
/** 区域 */
@property (nonatomic, strong) NSArray *district_arr;
@property (nonatomic, copy) NSString *district_id;
@property (nonatomic, copy) NSString *city_id;
@property (nonatomic, copy) NSString *province_id;
@property (nonatomic, copy) NSString *districtTxt;
@end

@implementation GXMyTeamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavbar];
    [self setUpTableView];
    [self setUpRefresh];
//    [self startShimmer];
    [self getTeamDataCount];
    [self getTeamDataRequest:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 260.f);
}
-(NSArray *)district_arr
{
    if (!_district_arr) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
        NSString *districtStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
//        if (districtStr == nil) {
//            return;
//        }
        NSData *jsonData = [districtStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *district = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *realArr = [NSMutableArray array];
        for (NSDictionary *Pro in (NSArray *)district[@"result"][@"list"]) {
            NSArray *sub = (NSArray *)Pro[@"city"];
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSDictionary *subPro in sub) {
                NSMutableArray *tempArr1 = [NSMutableArray array];
                for (NSDictionary *trdPro in subPro[@"area"]) {
                    [tempArr1 addObject:trdPro[@"alias"]];
                }
                [tempArr addObject:@{subPro[@"alias"]:tempArr1}];
            }
            [realArr addObject:@{Pro[@"alias"] : tempArr}];
        }
        _district_arr = [NSArray arrayWithArray:realArr];
    }
    return _district_arr;
}
-(NSMutableArray *)teams
{
    if (_teams == nil) {
        _teams = [NSMutableArray array];
    }
    return _teams;
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
//        [weakSelf getTeamDataRequest:YES];
//    }];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
//    self.tableView.mj_header.automaticallyChangeAlpha = YES;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        hx_strongify(weakSelf);
//        [strongSelf.tableView.mj_footer resetNoMoreData];
//        [strongSelf getCouponListRequest:YES];
//    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getTeamDataRequest:NO];
    }];
}
#pragma mark -- 点击事件
-(void)filterClicked
{
    NSMutableArray *showData = [NSMutableArray array];
    if (self.teamCount.areas && self.teamCount.areas.count) {
        for (GXMyTeamArea *area in self.teamCount.areas) {
            [showData addObject:area.area_alias];
        }
    }else{
        [showData addObjectsFromArray:self.district_arr];
    }
    // 1.Custom propery（自定义属性）
    NSDictionary *propertyDict = @{
        ZJPickerViewPropertyCanceBtnTitleKey : @"取消",
        ZJPickerViewPropertySureBtnTitleKey  : @"确定",
        ZJPickerViewPropertyTipLabelTextKey  : (self.districtTxt && self.districtTxt.length)?self.districtTxt:@"根据地区筛选", // 提示内容
        ZJPickerViewPropertyCanceBtnTitleColorKey : UIColorFromRGB(0x999999),
        ZJPickerViewPropertySureBtnTitleColorKey : HXControlBg,
        ZJPickerViewPropertyTipLabelTextColorKey :
            UIColorFromRGB(0x131D2D),
        ZJPickerViewPropertyLineViewBackgroundColorKey : UIColorFromRGB(0xF2F2F2),
        ZJPickerViewPropertyCanceBtnTitleFontKey : [UIFont systemFontOfSize:13.0f],
        ZJPickerViewPropertySureBtnTitleFontKey : [UIFont systemFontOfSize:13.0f],
        ZJPickerViewPropertyTipLabelTextFontKey : [UIFont systemFontOfSize:13.0f],
        ZJPickerViewPropertyPickerViewHeightKey : @260.0f,
        ZJPickerViewPropertyOneComponentRowHeightKey : @40.0f,
        ZJPickerViewPropertySelectRowTitleAttrKey : @{NSForegroundColorAttributeName : HXControlBg, NSFontAttributeName : [UIFont systemFontOfSize:15.0f]},
        ZJPickerViewPropertyUnSelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0x999999), NSFontAttributeName : [UIFont systemFontOfSize:15.0f]},
        ZJPickerViewPropertySelectRowLineBackgroundColorKey : UIColorFromRGB(0xF2F2F2),
        ZJPickerViewPropertyIsTouchBackgroundHideKey : @YES,
        ZJPickerViewPropertyIsShowSelectContentKey : @YES,
        ZJPickerViewPropertyIsScrollToSelectedRowKey: @YES,
        ZJPickerViewPropertyIsAnimationShowKey : @YES};
    
    // 2.Show（显示）
    hx_weakify(self);
    [ZJPickerView zj_showWithDataList:showData propertyDict:propertyDict completion:^(NSString *selectContent) {
        hx_strongify(weakSelf);
        NSArray *results = [selectContent componentsSeparatedByString:@"|"];
        
        NSArray *txts = [results.firstObject componentsSeparatedByString:@","];
        NSArray *rows = [results.lastObject componentsSeparatedByString:@","];
        
        // 省市区
        NSMutableString *selectStringCollection = [[NSMutableString alloc] init];
        [txts enumerateObjectsUsingBlock:^(NSString *selectString, NSUInteger idx, BOOL * _Nonnull stop) {
            if (selectString.length && ![selectString isEqualToString:@""]) {
                if (selectStringCollection.length) {
                    [selectStringCollection appendString:selectString];
                }else{
                    [selectStringCollection appendString:selectString];
                }
            }
        }];
        strongSelf.districtTxt = selectStringCollection;
        
        if ([[MSUserManager sharedInstance].curUserInfo.post_id isEqualToString:@"1"]) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
            NSString *districtStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
            
            if (districtStr == nil) {
                return;
            }
            NSData *jsonData = [districtStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *district = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            
            strongSelf.province_id = district[@"result"][@"list"][[rows[0] integerValue]][@"id"];
            strongSelf.city_id = district[@"result"][@"list"][[rows[0] integerValue]][@"city"][[rows[1] integerValue]][@"id"];
            strongSelf.district_id = district[@"result"][@"list"][[rows[0] integerValue]][@"city"][[rows[1] integerValue]][@"area"][[rows[2] integerValue]][@"id"];
        }else if ([[MSUserManager sharedInstance].curUserInfo.post_id isEqualToString:@"2"]) {
            strongSelf.province_id = @"";
            GXMyTeamArea *area = self.teamCount.areas[[rows[0] integerValue]];
            strongSelf.city_id = area.area_id;
            strongSelf.district_id = @"";
        }else{
            strongSelf.province_id = @"";
            GXMyTeamArea *area = self.teamCount.areas[[rows[0] integerValue]];
            strongSelf.city_id = area.area_id;
            strongSelf.district_id = @"";
        }
        [strongSelf getTeamDataCount];
        [strongSelf getTeamDataRequest:YES];
    }];
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
-(void)getTeamDataCount
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"post_id"] = [MSUserManager sharedInstance].curUserInfo.post_id;
    parameters[@"district_id"] = self.district_id?self.district_id:@"";
    parameters[@"city_id"] = self.city_id?self.city_id:@"";
    parameters[@"province_id"] = self.province_id?self.province_id:@"";
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"program/getTeamNum" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf); 
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.teamCount = [GXMyTeamCount yy_modelWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.header.teamCount = strongSelf.teamCount;
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
-(void)getTeamDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"post_id"] = [MSUserManager sharedInstance].curUserInfo.post_id;
    parameters[@"district_id"] = self.district_id?self.district_id:@"";
    parameters[@"city_id"] = self.city_id?self.city_id:@"";
    parameters[@"province_id"] = self.province_id?self.province_id:@"";
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"program/getTeamData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;

                [strongSelf.teams removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXMyTeam class] json:responseObject[@"data"]];
                [strongSelf.teams addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;

                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXMyTeam class] json:responseObject[@"data"]];
                    [strongSelf.teams addObjectsFromArray:arrt];
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
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.teams.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXMyTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:MyTeamCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GXMyTeam *team = self.teams[indexPath.row];
    cell.team = team;
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
