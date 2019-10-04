//
//  GXMarketTrendChildVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMarketTrendChildVC.h"
#import "GXMarketTrendCell.h"
#import "GXMarketTrendSectionHeader.h"
#import "GXMarketTrendHeader.h"
#import "GXGoodsDetailVC.h"

static NSString *const MarketTrendCell = @"MarketTrendCell";
@interface GXMarketTrendChildVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) GXMarketTrendHeader *header;
/* 是否向下滑动*/
@property(nonatomic,assign) BOOL isScrollDown;

@end

@implementation GXMarketTrendChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    // 初始化
    self.isScrollDown = YES;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.view.hxn_width = HX_SCREEN_WIDTH;
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 140.f);
}
-(GXMarketTrendHeader *)header
{
    if (_header == nil) {
        _header = [GXMarketTrendHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 140.f);
        hx_weakify(self);
        _header.cateClickedCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            [strongSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] animated:YES scrollPosition:UITableViewScrollPositionTop];
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
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXMarketTrendCell class]) bundle:nil] forCellReuseIdentifier:MarketTrendCell];
    
    self.tableView.tableHeaderView = self.header;
}
#pragma mark -- UIScrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat lastOffsetY = 0;

    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 判断滚动方向是向上还是向下
    self.isScrollDown = lastOffsetY < offsetY;
    lastOffsetY = scrollView.contentOffset.y;
    
    // 判断分类视图是否需要悬停
    if (offsetY >= 100) {
        //HXLog(@"悬停");
        self.header.categoryView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 40.f);
        [self.view addSubview:self.header.categoryView];
    }else{
        //HXLog(@"离开悬停");
        self.header.categoryView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 40.f);
        [self.header.cateSuperView addSubview:self.header.categoryView];
    }
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXMarketTrendCell *cell = [tableView dequeueReusableCellWithIdentifier:MarketTrendCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 65.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GXMarketTrendSectionHeader *header = [GXMarketTrendSectionHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 40.f);
    header.cateName.text = [NSString stringWithFormat:@"启赋-%zd",section];
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
    [self.navigationController pushViewController:dvc animated:YES];
}
// TableView分区标题即将展示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
//当前的tableView滚动的方向向上，并且是用户拖拽而产生滚动的（（主要判断tableView用户拖拽而滚动的，还是点击分类而滚动的）
    if (!self.isScrollDown
        && (tableView.dragging || tableView.decelerating)) {
        [self.header.categoryView selectItemAtIndex:section];
    }
}

// TableView分区标题展示结束
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
//当前的tableView滚动的方向向下，并且是用户拖拽而产生滚动的（（主要判断tableView用户拖拽而滚动的，还是点击分类而滚动的）
    if (self.isScrollDown && tableView.dragging) {
        [self.header.categoryView selectItemAtIndex:section+1];
    }
}

@end
