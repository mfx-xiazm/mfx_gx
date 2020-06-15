//
//  GXRenewCartCell.m
//  GX
//
//  Created by huaxin-01 on 2020/6/15.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXRenewCartCell.h"
#import "GXCartData.h"
#import "GXCartCell.h"
#import "GXRenewCartHeader.h"
#import "GXRenewCartSectionHeader.h"
#import <zhPopupController.h>
#import "zhAlertView.h"

static NSString *const CartCell = @"CartCell";
@interface GXRenewCartCell ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GXRenewCartHeader *header;
@property (nonatomic, strong) zhPopupController *alertPopVC;
@end
@implementation GXRenewCartCell

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
    self.tableView.backgroundColor = HXGlobalBg;
    self.tableView.scrollEnabled = NO;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXCartCell class]) bundle:nil] forCellReuseIdentifier:CartCell];
    
    self.tableView.tableHeaderView = self.header;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 40.f);
}
-(GXRenewCartHeader *)header
{
    if (!_header) {
        _header = [GXRenewCartHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 40.f);
        hx_weakify(self);
        _header.cartHeaderClickedCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            if (strongSelf.renewCartHeaderClickedCall) {
                strongSelf.renewCartHeaderClickedCall(index);
            }
        };
    }
    return _header;
}
-(void)setCartData:(GXCartData *)cartData
{
    _cartData = cartData;
    
    self.header.cartData = _cartData;
    
    [self.tableView reloadData];
}
#pragma mark -- UITableView数据源和代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cartData.goodsData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXCartCell *cell = [tableView dequeueReusableCellWithIdentifier:CartCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    GXCartShopGoods *goods = self.cartData.goodsData[indexPath.row];
    cell.goods = goods;
    hx_weakify(self);
    cell.cartHandleCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        if (index == 2) {
            if (!goods.is_checked) {//取消选中
                strongSelf.cartData.is_checked = NO;
            }else{//选中
                // 判断店铺要选中
                __block BOOL isStoreSelect = YES;
                [strongSelf.cartData.goodsData enumerateObjectsUsingBlock:^(GXCartShopGoods * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (!obj.is_checked) {
                        isStoreSelect = NO;
                        *stop = YES;
                    }
                }];
                strongSelf.cartData.is_checked = isStoreSelect;
            }
        }
        if (strongSelf.renewCartNumHandleCall) {
            strongSelf.renewCartNumHandleCall(index);
        }
    };
    MGSwipeButton *btn = [MGSwipeButton buttonWithTitle:@"" icon:HXGetImage(@"垃圾桶 (1)") backgroundColor:UIColorFromRGB(0xEA4A5C)];
    btn.buttonWidth = 60.f;
    btn.callback = ^BOOL(MGSwipeTableCell * _Nonnull cell) {
        hx_strongify(weakSelf);
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要删除选中商品吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
            [strongSelf.alertPopVC dismiss];
        }];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"删除" handler:^(zhAlertButton * _Nonnull button) {
            [strongSelf.alertPopVC dismiss];
            strongSelf.renewCartDelCall(goods.cart_id);
        }];
        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
        strongSelf.alertPopVC = [[zhPopupController alloc] initWithView:alert size:alert.bounds.size];
        [strongSelf.alertPopVC show];
        return YES;
    };
    cell.rightButtons = @[btn];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 110.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f*2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GXRenewCartSectionHeader *header = [GXRenewCartSectionHeader loadXibView];
    header.hxn_size = CGSizeMake(tableView.hxn_width, 40.f*2);
    
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark -- MGSwipeTableCell代理
-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion
{
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
