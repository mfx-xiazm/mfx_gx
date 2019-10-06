//
//  GXHelpVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXHelpVC.h"
#import "GXHelpCell.h"
#import "GXWebContentVC.h"

static NSString *const HelpCell = @"HelpCell";
@interface GXHelpVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GXHelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"使用帮助"];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(void)setUpTableView
{
    self.tableView.estimatedRowHeight = 70.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXHelpCell class]) bundle:nil] forCellReuseIdentifier:HelpCell];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:HelpCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // 返回这个模型对应的cell高度
//    return 90.f;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXWebContentVC *wvc = [GXWebContentVC new];
    wvc.url = @"http://news.cctv.com/2019/10/03/ARTI2EUlwRGH3jMPI6cAVqti191003.shtml";
    wvc.navTitle = @"使用帮助";
    [self.navigationController pushViewController:wvc animated:YES];
}

@end
