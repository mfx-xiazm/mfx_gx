//
//  GXChooseCouponVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXChooseCouponVC.h"
#import "GXMyCouponCell.h"
#import "GXMyCoupon.h"

static NSString *const MyCouponCell = @"MyCouponCell";
@interface GXChooseCouponVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 列表 */
@property(nonatomic,strong) NSArray *coupons;
@end

@implementation GXChooseCouponVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"选择优惠券"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(sureClicked) title:@"确定" font:[UIFont systemFontOfSize:14] titleColor:[UIColor whiteColor] highlightedColor:[UIColor whiteColor] titleEdgeInsets:UIEdgeInsetsZero];
    [self setUpTableView];
    [self getCouponUseDataRequest];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXMyCouponCell class]) bundle:nil] forCellReuseIdentifier:MyCouponCell];
}
-(void)sureClicked
{
    if (self.getUseCouponCall) {
        self.getUseCouponCall((self.selectCoupon && self.selectCoupon.isSelected)?self.selectCoupon:nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 接口请求
-(void)getCouponUseDataRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"provider_uid"] = self.provider_uid;//店铺id 为0表示平台的优惠券
    parameters[@"price_amount"] = self.price_amount;//店铺下商品总价格 如果是平台的话则是所有的店铺的商品的价格总和
       
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"getCouponUseData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.coupons = [NSArray yy_modelArrayWithClass:[GXMyCoupon class] json:responseObject[@"data"]];
            if (strongSelf.selectCoupon) {
                for (GXMyCoupon *coupon in strongSelf.coupons) {
                    if ([coupon.coupon_id isEqualToString:strongSelf.selectCoupon.coupon_id]) {
                        coupon.isSelected = YES;
                        strongSelf.selectCoupon = coupon;// 重新赋值
                        break;
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.tableView.hidden = NO;
                [strongSelf.tableView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.coupons.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXMyCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCouponCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GXMyCoupon *useCoupon = self.coupons[indexPath.row];
    useCoupon.provider_uid = self.provider_uid;
    useCoupon.shop_name = self.shop_name;
    cell.useCoupon = useCoupon;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 90.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXMyCoupon *useCoupon = self.coupons[indexPath.row];
    useCoupon.isSelected = !useCoupon.isSelected;
    self.selectCoupon = useCoupon;
    [tableView reloadData];
}


@end
