//
//  GXRegisterAuthVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXRegisterAuthVC.h"
#import "GXRegisterAuthHeader.h"
#import "GXRegisterAuthCell.h"
#import "GXRegisterAuthFooter.h"

static NSString *const RegisterAuthCell = @"RegisterAuthCell";
@interface GXRegisterAuthVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) GXRegisterAuthHeader *header;
/* 尾视图 */
@property(nonatomic,strong) GXRegisterAuthFooter *footer;
@end

@implementation GXRegisterAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"注册验证"];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 480);
    self.footer.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 160);
}
#pragma mark -- 视图相关
-(GXRegisterAuthHeader *)header
{
    if (_header == nil) {
        _header = [GXRegisterAuthHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 480);
        _header.target = self;
    }
    return _header;
}
-(GXRegisterAuthFooter *)footer
{
    if (_footer == nil) {
        _footer = [GXRegisterAuthFooter loadXibView];
        _footer.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 160);
    }
    return _footer;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXRegisterAuthCell class]) bundle:nil] forCellReuseIdentifier:RegisterAuthCell];
    
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXRegisterAuthCell *cell = [tableView dequeueReusableCellWithIdentifier:RegisterAuthCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 300.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    RCWebContentVC *wvc = [RCWebContentVC new];
//    wvc.navTitle = @"公告";
//    wvc.url = @"https://www.baidu.com/";
//    [self.navigationController pushViewController:wvc animated:YES];
}


@end
