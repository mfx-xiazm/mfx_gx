//
//  GXGetCouponView.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXGetCouponView.h"
#import "GXMyCouponCell.h"
#import "GXCartData.h"
#import "GXMyCoupon.h"

static NSString *const MyCouponCell = @"MyCouponCell";

@interface GXGetCouponView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *shop_name;

@end
@implementation GXGetCouponView

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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXMyCouponCell class]) bundle:nil] forCellReuseIdentifier:MyCouponCell];
}
- (IBAction)closeClicked:(UIButton *)sender {
    if (self.closeViewCall) {
        self.closeViewCall();
    }
}

-(void)setCartData:(GXCartData *)cartData
{
    _cartData = cartData;
    self.shop_name.text = [NSString stringWithFormat:@"%@通用",_cartData.shop_name];
    [self.tableView reloadData];
}
-(void)drawCouponRequest:(GXMyCoupon *)coupon
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"rule_id"] = coupon.rule_id;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/drawCoupon" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            NSMutableArray *temp = [NSMutableArray arrayWithArray:strongSelf.cartData.coupons];
            [temp removeObject:coupon];
            strongSelf.cartData.coupons = temp;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
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
    return self.cartData.coupons.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXMyCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCouponCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GXMyCoupon *coupon = self.cartData.coupons[indexPath.row];
    coupon.seaType = 1;
    coupon.shop_name = self.cartData.shop_name;
    coupon.provider_uid = self.cartData.provider_uid;
    cell.coupon = coupon;
    hx_weakify(self);
    cell.getCouponCall = ^{
        hx_strongify(weakSelf);
        [strongSelf drawCouponRequest:coupon];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 90.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
