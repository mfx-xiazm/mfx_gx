//
//  GXExpressShowView.m
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXExpressShowView.h"
#import "GXExpressShowCell.h"

static NSString *const ExpressShowCell = @"ExpressShowCell";
@interface GXExpressShowView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation GXExpressShowView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.tableView.rowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXExpressShowCell class]) bundle:nil] forCellReuseIdentifier:ExpressShowCell];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self bezierPathByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXExpressShowCell *cell = [tableView dequeueReusableCellWithIdentifier:ExpressShowCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 40.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
