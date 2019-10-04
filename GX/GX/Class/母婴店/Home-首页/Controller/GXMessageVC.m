//
//  GXMessageVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMessageVC.h"
#import "GXMessageCell.h"
#import "GXWebContentVC.h"

static NSString *const MessageCell = @"MessageCell";
@interface GXMessageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GXMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"消息"];
    [self setUpTableView];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXMessageCell class]) bundle:nil] forCellReuseIdentifier:MessageCell];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 70.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXWebContentVC *wvc = [GXWebContentVC new];
    wvc.url = @"http://news.cctv.com/2019/10/03/ARTI2EUlwRGH3jMPI6cAVqti191003.shtml";
    wvc.navTitle = @"消息详情";
    [self.navigationController pushViewController:wvc animated:YES];
}

@end
