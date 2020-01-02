//
//  GXSankPriceVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXSankPriceVC.h"
#import "GXSankPriceCell.h"
#import "GXSankPriceSectionFooter.h"
#import "GXChooseValidAddressView.h"
#import <zhPopupController.h>
#import "GXSankPrice.h"
#import "GXUpOrderVC.h"
#import "GXMyAddress.h"

static NSString *const SankPriceCell = @"SankPriceCell";
@interface GXSankPriceVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 选择地址视图 */
@property(nonatomic,strong) GXChooseValidAddressView *addressView;
/* 地址列表 */
@property(nonatomic,strong) NSArray *addressList;
/* titileView */
@property(nonatomic,strong) UIView *titileView;
/* 地址text */
@property(nonatomic,strong) UILabel *addressText;
/* 地址展开 */
@property(nonatomic,strong) UIImageView *expandImg;
/* 地址图标 */
@property(nonatomic,strong) UIImageView *addressImg;
/* 地址id */
@property(nonatomic,copy) NSString *address_id;
/** 数组 */
@property (nonatomic,strong) NSMutableArray *goodsPrices;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
@end

@implementation GXSankPriceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpRefresh];
    [self startShimmer];
    [self getAddressListRequest];
    [self goodsSortByPriceRequest:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(GXChooseValidAddressView *)addressView
{
    if (_addressView == nil) {
        _addressView = [GXChooseValidAddressView loadXibView];
        _addressView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 360);
    }
    return _addressView;
}
-(NSMutableArray *)goodsPrices
{
    if (_goodsPrices == nil) {
        _goodsPrices = [NSMutableArray array];
    }
    return _goodsPrices;
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];

    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-100, 40.f);
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:13];
    title.text = @"配送至：请选择";
    CGSize titleSize = [title sizeThatFits:CGSizeZero];
    title.hxn_x = (titleView.hxn_width-titleSize.width)/2.0;
    title.hxn_y = (titleView.hxn_height-titleSize.height)/2.0;
    title.hxn_width = titleSize.width;
    title.hxn_height = titleSize.height;
    self.addressText = title;
    [titleView addSubview:title];
    
    UIImageView *dw = [[UIImageView alloc] initWithImage:HXGetImage(@"地址白色")];
    dw.hxn_centerY = titleView.hxn_centerY;
    dw.hxn_x = CGRectGetMinX(title.frame) - 20.f;
    self.addressImg = dw;
    [titleView addSubview:dw];
    
    UIImageView *zk = [[UIImageView alloc] initWithImage:HXGetImage(@"展开白")];
    zk.hxn_centerY = titleView.hxn_centerY;
    zk.hxn_x = CGRectGetMaxX(title.frame) + 10.f;
    self.expandImg = zk;
    [titleView addSubview:zk];
    
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    coverBtn.frame = titleView.bounds;
    [coverBtn addTarget:self action:@selector(chooseAddressClicked) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:coverBtn];

    self.titileView = titleView;
    
    self.navigationItem.titleView = titleView;
}
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXSankPriceCell class]) bundle:nil] forCellReuseIdentifier:SankPriceCell];
    
    hx_weakify(self);
    [self.tableView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
        [weakSelf startShimmer];
        [weakSelf goodsSortByPriceRequest:YES];
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
        [strongSelf goodsSortByPriceRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf goodsSortByPriceRequest:NO];
    }];
}
-(void)goodsSortByPriceRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goods_id;//商品id
    if (self.address_id && self.address_id.length) {
        parameters[@"address_id"] = self.address_id;
    }
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/goodsSortByPrice" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                
                [strongSelf.goodsPrices removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXSankPrice class] json:responseObject[@"data"]];
                [strongSelf.goodsPrices addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;

                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXSankPrice class] json:responseObject[@"data"]];
                    [strongSelf.goodsPrices addObjectsFromArray:arrt];
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
-(void)getAddressListRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getAddressList" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.addressList = [NSArray yy_modelArrayWithClass:[GXMyAddress class] json:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.tableView.hidden = NO;
                [strongSelf.tableView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 业务逻辑
-(void)addOrderCartRequest:(NSString *)goods_id cart_num:(NSInteger)cart_num specs_attrs:(NSString *)specs_attrs logistics_com_id:(NSString *)logistics_com_id sku_id:(NSString *)sku_id
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = goods_id;//商品id
    parameters[@"cart_num"] = @(cart_num);//商品数量
    parameters[@"specs_attrs"] = specs_attrs;//商品规格
    parameters[@"is_try"] = @(0);//是否试用装商品
    parameters[@"is_checked"] = @"1";//0未选择；1已选择
    parameters[@"logistics_com_id"] = logistics_com_id;
    parameters[@"sku_id"] = sku_id;

    [HXNetworkTool POST:HXRC_M_URL action:@"admin/addOrderCart" parameters:parameters success:^(id responseObject) {
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 点击事件
-(void)chooseAddressClicked
{
    self.addressView.addressList = self.addressList;
    hx_weakify(self);
    self.addressView.chooseAddressCall = ^(GXMyAddress * _Nullable address) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        if (address) {
            strongSelf.addressText.text = [NSString stringWithFormat:@"配送至：%@",address.area_name];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                CGSize titleSize = [strongSelf.addressText sizeThatFits:CGSizeZero];
                strongSelf.addressText.hxn_centerX = strongSelf.titileView.hxn_centerX;
                strongSelf.addressText.hxn_width = (titleSize.width>200.f)?200.f:titleSize.width;
                
                strongSelf.addressImg.hxn_centerY = strongSelf.titileView.hxn_centerY;
                strongSelf.addressImg.hxn_x = CGRectGetMinX(strongSelf.addressText.frame) - 20.f;
                
                strongSelf.expandImg.hxn_centerY = strongSelf.titileView.hxn_centerY;
                strongSelf.expandImg.hxn_x = CGRectGetMaxX(strongSelf.addressText.frame) + 10.f;
                
                [strongSelf.titileView setNeedsLayout];
                [strongSelf.titileView layoutIfNeeded];
            });
            strongSelf.address_id = address.address_id;
            [strongSelf goodsSortByPriceRequest:YES];
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:self.addressView duration:0.25 springAnimated:NO];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.goodsPrices.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXSankPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:SankPriceCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GXSankPrice *sank = self.goodsPrices[indexPath.section];
    cell.sank = sank;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 70.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.goodsPrices.count) {
        GXSankPrice *sank = self.goodsPrices[section];
        return sank.isExpand?100.f:0.f;
    }else{
        return CGFLOAT_MIN;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    GXSankPrice *sank = self.goodsPrices[section];
    if (sank.isExpand) {
        GXSankPriceSectionFooter *footer = [GXSankPriceSectionFooter loadXibView];
        footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 100.f);
        footer.sank = sank;
        hx_weakify(self);
        footer.priceSankHandleCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            if (index == 1) {
                [strongSelf addOrderCartRequest:sank.goods_id cart_num:sank.buy_num specs_attrs:[NSString stringWithFormat:@"%@,%@",sank.specs_attrs,sank.logistics_com_name] logistics_com_id:sank.logistics_com_id sku_id:sank.sku_id];
            }else{
                GXUpOrderVC *ovc = [GXUpOrderVC new];
                ovc.goods_id = sank.goods_id;
                ovc.goods_num = [NSString stringWithFormat:@"%ld",(long)sank.buy_num];
                ovc.specs_attrs = [NSString stringWithFormat:@"%@,%@",sank.specs_attrs,sank.logistics_com_name];
                ovc.sku_id = sank.sku_id;
                ovc.logistics_com_id = sank.logistics_com_id;
                [strongSelf.navigationController pushViewController:ovc animated:YES];
            }
        };
        return footer;
    }else{
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXSankPrice *sank = self.goodsPrices[indexPath.section];
    sank.isExpand = !sank.isExpand;
    [tableView reloadData];
}
@end
