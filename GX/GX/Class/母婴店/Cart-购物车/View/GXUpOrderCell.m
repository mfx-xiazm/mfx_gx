//
//  GXUpOrderCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXUpOrderCell.h"
#import "GXUpOrderGoodsCell.h"
#import "GXConfirmOrder.h"
#import "GXMyCoupon.h"
#import "GXUpOrderCellHeader.h"
#import "GXUpOrderCellSectionFooter.h"
#import "GXUpOrderCellFooter.h"

static NSString *const UpOrderGoodsCell = @"UpOrderGoodsCell";
@interface GXUpOrderCell ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GXUpOrderCellHeader *header;
@property (nonatomic, strong) GXUpOrderCellFooter *footer;
@end
@implementation GXUpOrderCell

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
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = NO;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXUpOrderGoodsCell class]) bundle:nil] forCellReuseIdentifier:UpOrderGoodsCell];
    
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.header.frame = CGRectMake(0, 0, self.tableView.hxn_width, 40.f);
    self.footer.frame = CGRectMake(0, 0, self.tableView.hxn_width, 120.f);
}
-(GXUpOrderCellHeader *)header
{
    if (!_header) {
        _header = [GXUpOrderCellHeader loadXibView];
        _header.frame = CGRectMake(0, 0, self.tableView.hxn_width, 40.f);
    }
    return _header;
}
-(GXUpOrderCellFooter *)footer
{
    if (!_footer) {
        _footer = [GXUpOrderCellFooter loadXibView];
        _footer.frame = CGRectMake(0, 0, self.tableView.hxn_width, 120.f);
        hx_weakify(self);
        _footer.couponCall = ^{
            hx_strongify(weakSelf);
            if (strongSelf.chooseCouponCall) {
                strongSelf.chooseCouponCall();
            }
        };
    }
    return _footer;
}
-(void)setOrderData:(GXConfirmOrderData *)orderData
{
    _orderData = orderData;
    self.header.shop_name.text = _orderData.shop_name;

    if ([_orderData.provider_uid isEqualToString:@"0"]) {
        self.footer.hxn_size = CGSizeMake(self.tableView.hxn_width, 80.f);
    }else{
        self.footer.hxn_size = CGSizeMake(self.tableView.hxn_width, 120.f);
    }
    self.footer.orderData = _orderData;
    
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderData.goods.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXUpOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:UpOrderGoodsCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GXConfirmOrderGoods *upGoods = self.orderData.goods[indexPath.row];
    cell.upGoods = upGoods;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 110.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 160.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    GXUpOrderCellSectionFooter *footer = [GXUpOrderCellSectionFooter loadXibView];
    footer.orderData = self.orderData;
    footer.hxn_size = CGSizeMake(tableView.hxn_width, 160.f);
    return footer;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
