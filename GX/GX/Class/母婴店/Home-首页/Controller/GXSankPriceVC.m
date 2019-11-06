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

static NSString *const SankPriceCell = @"SankPriceCell";
@interface GXSankPriceVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* titileView */
@property(nonatomic,strong) UIView *titileView;
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
    [self goodsSortByPriceRequest:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
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
    [self.navigationItem setTitle:@"价格排序"];
    /*
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-100, 40.f);
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:13];
    title.text = @"配送至：咸宁市咸安区";
    CGSize titleSize = [title sizeThatFits:CGSizeZero];
    title.hxn_x = (titleView.hxn_width-titleSize.width)/2.0;
    title.hxn_y = (titleView.hxn_height-titleSize.height)/2.0;
    title.hxn_width = titleSize.width;
    title.hxn_height = titleSize.height;
    [titleView addSubview:title];
    
    UIImageView *dw = [[UIImageView alloc] initWithImage:HXGetImage(@"地址")];
    dw.hxn_centerY = titleView.hxn_centerY;
    dw.hxn_x = CGRectGetMinX(title.frame) - 20.f;
    [titleView addSubview:dw];
    
    UIImageView *zk = [[UIImageView alloc] initWithImage:HXGetImage(@"展开")];
    zk.hxn_centerY = titleView.hxn_centerY;
    zk.hxn_x = CGRectGetMaxX(title.frame) + 10.f;
    [titleView addSubview:zk];
    
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    coverBtn.frame = titleView.bounds;
    [coverBtn addTarget:self action:@selector(chooseAddressClicked) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:coverBtn];

    self.titileView = titleView;
    
    self.navigationItem.titleView = titleView;
    */
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
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"goodsSortByPrice" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
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
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 点击事件
-(void)chooseAddressClicked
{
    GXChooseValidAddressView *vdv = [GXChooseValidAddressView loadXibView];
    vdv.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 300);
    
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:vdv duration:0.25 springAnimated:NO];
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
    GXSankPrice *sank = self.goodsPrices[section];
    return sank.isExpand?100.f:0.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    GXSankPrice *sank = self.goodsPrices[section];
    if (sank.isExpand) {
        GXSankPriceSectionFooter *footer = [GXSankPriceSectionFooter loadXibView];
        footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 100.f);
        footer.sank = sank;
        //hx_weakify(self);
        footer.priceSankHandleCall = ^(NSInteger index) {
            //hx_strongify(weakSelf);
            if (index == 1) {
                HXLog(@"加入购物车");
            }else{
                HXLog(@"立即购买");
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
