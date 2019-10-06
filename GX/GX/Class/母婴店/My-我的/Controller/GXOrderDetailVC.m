//
//  GXOrderDetailVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXOrderDetailVC.h"
#import "GXOrderDetailHeader.h"
#import "GXUpOrderGoodsCell.h"
#import "GXMyOrderHeader.h"
#import "GXOrderDetailFooter.h"
#import "GXRefundDetailFooter.h"
#import "GXExpressDetailVC.h"
#import "GXEvaluateVC.h"

static NSString *const UpOrderGoodsCell = @"UpOrderGoodsCell";
@interface GXOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) GXOrderDetailHeader *header;
/* 退款状态尾部视图 */
@property(nonatomic,strong) GXRefundDetailFooter *footer;
@end

@implementation GXOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"订单详情"];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 225);
    self.footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 110);

}
-(GXOrderDetailHeader *)header
{
    if (_header == nil) {
        _header = [GXOrderDetailHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 225);
    }
    return _header;
}
-(GXRefundDetailFooter *)footer
{
    if (_footer == nil) {
        _footer = [GXRefundDetailFooter loadXibView];
        _footer.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 110);
    }
    return _footer;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXUpOrderGoodsCell class]) bundle:nil] forCellReuseIdentifier:UpOrderGoodsCell];
    
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
}
#pragma mark -- 点击事件
- (IBAction)orderHandleBtnClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        GXExpressDetailVC *evc = [GXExpressDetailVC new];
        [self.navigationController pushViewController:evc animated:YES];
    }else{
        GXEvaluateVC *evc = [GXEvaluateVC new];
        [self.navigationController pushViewController:evc animated:YES];
    }
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXUpOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:UpOrderGoodsCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 110.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GXMyOrderHeader *header = [GXMyOrderHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44.f);
    
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 230.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    GXOrderDetailFooter *footer = [GXOrderDetailFooter loadXibView];
    footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 230.f);
    
    return footer;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
