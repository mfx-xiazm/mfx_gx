//
//  GXRenewMyOrderBigCell.m
//  GX
//
//  Created by huaxin-01 on 2020/6/18.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXRenewMyOrderBigCell.h"
#import "GXRenewMyOrderCell.h"
#import "GXMyOrder.h"
#import "GXMyRefund.h"
#import "GXRenewMyOrderBigCellHeader.h"

static NSString *const RenewMyOrderCell = @"RenewMyOrderCell";
@interface GXRenewMyOrderBigCell ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
@implementation GXRenewMyOrderBigCell

- (void)awakeFromNib {
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXRenewMyOrderCell class]) bundle:nil] forCellReuseIdentifier:RenewMyOrderCell];
}
-(void)setMyOrder:(GXMyOrder *)myOrder
{
    _myOrder = myOrder;
    [self.tableView reloadData];
}
-(void)setMyRefund:(GXMyRefund *)myRefund
{
    _myRefund = myRefund;
    [self.tableView reloadData];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.status !=5) {
        return self.myOrder.goods.count;
    }else{
        return self.myRefund.goods.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXRenewMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:RenewMyOrderCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.status !=5) {
        GXMyOrderGoods *goods = self.myOrder.goods[indexPath.row];
        goods.refund_status = self.myOrder.refund_status;
        goods.status = self.myOrder.status;
        cell.goods = goods;
    }else{
        GYMyRefundGoods *refund = self.myRefund.goods[indexPath.row];
        cell.return_num = self.myRefund.return_num;
        cell.refundGoods = refund;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 110.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GXRenewMyOrderBigCellHeader *header = [GXRenewMyOrderBigCellHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 40.f);
    if (self.status !=5) {
        header.myOrder = self.myOrder;
    }else{
        header.myRefund = self.myRefund;
    }
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellClickedCall) {
        self.cellClickedCall();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
