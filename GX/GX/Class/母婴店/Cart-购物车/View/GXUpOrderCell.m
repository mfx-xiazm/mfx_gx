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

static NSString *const UpOrderGoodsCell = @"UpOrderGoodsCell";
@interface GXUpOrderCell ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *shop_name;
@property (weak, nonatomic) IBOutlet UILabel *totalFreight;
@property (weak, nonatomic) IBOutlet UILabel *couponAmount;
@property (weak, nonatomic) IBOutlet UILabel *totalAmount;
@property (weak, nonatomic) IBOutlet UILabel *goodsNum;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponViewHeight;

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
    self.tableView.backgroundColor = HXGlobalBg;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXUpOrderGoodsCell class]) bundle:nil] forCellReuseIdentifier:UpOrderGoodsCell];
}
- (IBAction)couponClicked:(UIButton *)sender {
    if (self.chooseCouponCall) {
        self.chooseCouponCall();
    }
}

-(void)setOrderData:(GXConfirmOrderData *)orderData
{
    _orderData = orderData;
    
    self.shop_name.text = _orderData.shop_name;
    self.totalFreight.text = [NSString stringWithFormat:@"￥%@",_orderData.shopActTotalFreight];
    
    if ([_orderData.provider_uid isEqualToString:@"0"]) {// 平台自营
        self.couponView.hidden = YES;
        self.couponViewHeight.constant = 0.f;
        self.couponAmount.text = @"";
        
        self.totalAmount.text = [NSString stringWithFormat:@"￥%.2f",[_orderData.shopActTotalAmount floatValue]];
    }else{
        self.couponView.hidden = NO;
        self.couponViewHeight.constant = 40.f;
        
        // shopActTotalAmount - 优惠
        if (_orderData.selectedCoupon) {// 存在优惠
            self.totalAmount.text = [NSString stringWithFormat:@"￥%.2f",[_orderData.shopActTotalAmount floatValue] - [_orderData.selectedCoupon.coupon_amount floatValue]];
            self.couponAmount.text = [NSString stringWithFormat:@"-￥%@",_orderData.selectedCoupon.coupon_amount];
        }else{
           self.totalAmount.text = [NSString stringWithFormat:@"￥%.2f",[_orderData.shopActTotalAmount floatValue]];
           self.couponAmount.text = @"";
        }
    }
    self.goodsNum.text = [NSString stringWithFormat:@"共%lu件商品",(unsigned long)_orderData.goods.count];
    
    [self.tableView reloadData];
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
