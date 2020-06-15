//
//  GXTestViewController.m
//  GX
//
//  Created by huaxin-01 on 2020/6/12.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXTestViewController.h"
#import "GXMessageCell.h"
#import "GXMessage.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorLineView.h>

static NSString *const MessageCell = @"MessageCell";

@interface GXTestViewController ()<UITableViewDelegate,UITableViewDataSource,JXCategoryViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBgViewHeight;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 列表 */
@property(nonatomic,strong) NSMutableArray *messages;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, assign) CGFloat gradientProgress;
@end

@implementation GXTestViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.topBgView.backgroundColor = HXRGBAColor(66, 48, 242, 0);
    [self setUpCategoryView];
    [self setUpTableView];
    [self startShimmer];
    [self getMessageDataRequest:YES];
}
- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UITableView *tableView = self.tableView;
    UIImageView *headerView = self.headerView;
    
    CGFloat imageHeight = 180;
    CGRect headerFrame = headerView.frame;
    
    if (tableView.contentInset.top == 0) {
        UIEdgeInsets inset = UIEdgeInsetsZero;
        if (@available(iOS 11,*)) {
            inset.bottom = self.view.safeAreaInsets.bottom;
        }
        tableView.scrollIndicatorInsets = inset;
        inset.top = imageHeight;
        tableView.contentInset = inset;
        tableView.contentOffset = CGPointMake(0, -inset.top);
    }
    
    if (CGRectGetHeight(headerFrame) != imageHeight) {
        headerView.frame = [self headerImageFrame];
    }
}

- (CGRect) headerImageFrame {
    UITableView *tableView = self.tableView;
    
    CGFloat imageHeight = 180;
    
    CGFloat contentOffsetY = tableView.contentOffset.y + tableView.contentInset.top;
    if (contentOffsetY < 0) {
        imageHeight += -contentOffsetY;
    }
    
    CGRect headerFrame = self.view.bounds;
    if (contentOffsetY > 0) {
        headerFrame.origin.y -= contentOffsetY;
    }
    headerFrame.size.height = imageHeight;
    
    return headerFrame;
}
-(NSMutableArray *)messages
{
    if (_messages == nil) {
        _messages = [NSMutableArray array];
    }
    return _messages;
}
#pragma mark -- 视图相关
-(void)setUpCategoryView
{
           _categoryView.backgroundColor = [UIColor clearColor];
           _categoryView.titleLabelZoomEnabled = NO;
           _categoryView.titles = @[@"奶粉", @"纸尿裤"];
           _categoryView.titleFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
           _categoryView.titleColor = [UIColor blackColor];
           _categoryView.titleSelectedColor = HXControlBg;
           _categoryView.defaultSelectedIndex = 0;
           _categoryView.delegate = self;
           //    _categoryView.contentScrollView = self.scrollView;
           
           JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
           lineView.verticalMargin = 5.f;
           lineView.indicatorColor = HXControlBg;
           _categoryView.indicators = @[lineView];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXMessageCell class]) bundle:nil] forCellReuseIdentifier:MessageCell];
    
    _headerView = [[UIImageView alloc] init];
    _headerView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 180);
    _headerView.image = HXGetImage(@"行情-纸尿裤");
    _headerView.clipsToBounds = YES;
    _headerView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:_headerView aboveSubview:_tableView];
    
    hx_weakify(self);
    [self.tableView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
        [weakSelf startShimmer];
        [weakSelf getMessageDataRequest:YES];
    }];
}
//实现scrollView代理
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
////全局变量记录滑动前的contentOffset
//   lastContentOffset = scrollView.contentOffset.y;//判断上下滑动时
//
////    lastContentOffset = scrollView.contentOffset.x;//判断左右滑动时
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat headerHeight = CGRectGetHeight(self.headerView.frame);
    if (@available(iOS 11,*)) {
        headerHeight -= self.view.safeAreaInsets.top;
    } else {
        headerHeight -= [self.topLayoutGuide length];
    }
    CGFloat progress = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGFloat gradientProgress = MIN(1, MAX(0, progress  / headerHeight));
    gradientProgress = gradientProgress * gradientProgress;
    if (gradientProgress != _gradientProgress) {
        _gradientProgress = gradientProgress;
        self.topBgView.backgroundColor = HXRGBAColor(66, 48, 242, _gradientProgress);
    }
    self.headerView.frame = [self headerImageFrame];
    
//    CGRect frame =  self.categoryView.frame;
//    frame.origin.y = -progress;
//    if (frame.origin.y > self.HXStatusHeight) {
//        self.categoryView.frame = frame;
//    }
//    if (self.topBgViewHeight.constant == self.HXStatusHeight) {
//        frame.size.width = 200;
    self.topBgViewHeight.constant = 148-progress;
//        [self.navigationItem setTitleView:self.categoryView];
//    }else{
//        frame.size.width = HX_SCREEN_WIDTH;
//        [self.navigationItem setTitleView:nil];
//        [self.view addSubview:self.categoryView];
//    }
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
    return self.messages.count*3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GXMessage *msg = self.messages[0];
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
    
}

@end
