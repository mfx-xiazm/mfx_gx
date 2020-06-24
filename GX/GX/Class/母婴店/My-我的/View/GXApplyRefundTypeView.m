//
//  GXApplyRefundTypeView.m
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXApplyRefundTypeView.h"
#import "GXApplyRefundTypeCell.h"

static NSString *const ApplyRefundTypeCell = @"ApplyRefundTypeCell";
@interface GXApplyRefundTypeView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *currentTitle;
@end

@implementation GXApplyRefundTypeView
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
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXApplyRefundTypeCell class]) bundle:nil] forCellReuseIdentifier:ApplyRefundTypeCell];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self bezierPathByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
}
- (IBAction)sureClicked:(UIButton *)sender {
    if (self.currentTitle.length) {
        self.showTextField.text = self.currentTitle;
    }
    if (self.selectCall) {
        self.selectCall();
    }
}

-(void)setShowTextField:(UITextField *)showTextField
{
    _showTextField = showTextField;
    self.currentTitle = _showTextField.text;
}
-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [self.tableView reloadData];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXApplyRefundTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:ApplyRefundTypeCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.showTxt.text = self.dataSource[indexPath.row];
    cell.selectImg.image = [cell.showTxt.text isEqualToString:self.currentTitle]?HXGetImage(@"协议选择"):HXGetImage(@"协议未选");
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 50.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentTitle = self.dataSource[indexPath.row];
    [tableView reloadData];
}
@end
