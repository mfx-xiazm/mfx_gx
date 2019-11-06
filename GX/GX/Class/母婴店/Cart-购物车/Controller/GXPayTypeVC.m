//
//  GXPayTypeVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXPayTypeVC.h"
#import "GXPayTypeCell.h"
#import "GXPartnerDataSectionHeader.h"
#import "GXPayTypeHeader.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "GXUpOrderVC.h"
#import "GXOrderDetailVC.h"
#import "GXOrderPay.h"
#import "GXPayType.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import "GXPayResultVC.h"

static NSString *const PayTypeCell = @"PayTypeCell";
@interface GXPayTypeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) GXPayTypeHeader *header;
/** vc控制器 */
@property (nonatomic,strong) NSMutableArray *controllers;
/* 订单信息 */
@property(nonatomic,strong) GXOrderPay *orderPay;
/* 选中的支付方式 */
@property(nonatomic,strong) GXPayType *selectPayType;
/* 支付方式 */
@property(nonatomic,strong) NSArray *payTypes;
@end

@implementation GXPayTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    //注册支付状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doPayPush:) name:HXPayPushNotification object:nil];
    hx_weakify(self);
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[GXUpOrderVC class]]) {
            hx_strongify(weakSelf);
            [strongSelf.controllers removeObjectAtIndex:idx];
            *stop = YES;
        }
    }];
    [self.navigationController setViewControllers:self.controllers];
    
    [self setUpTableView];
    
    [self getPayOrderDataRequest];
}
- (NSMutableArray *)controllers {
    if (!_controllers) {
        _controllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    }
    return _controllers;
}
-(NSArray *)payTypes
{
    if (_payTypes == nil) {
        NSArray *pays = @[@{@"payType":@"1",@"typeName":@"支付宝",@"typeImg":HXGetImage(@"支付宝")},@{@"payType":@"2",@"typeName":@"微信支付",@"typeImg":HXGetImage(@"微信支付")},@{@"payType":@"3",@"typeName":@"网银支付",@"typeImg":HXGetImage(@"网商银行")},@{@"payType":@"4",@"typeName":@"银联支付",@"typeImg":HXGetImage(@"银联")}];
        _payTypes = [NSArray yy_modelArrayWithClass:[GXPayType class] json:pays];
    }
    return _payTypes;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 220.f);
}
-(GXPayTypeHeader *)header
{
    if (_header == nil) {
        _header = [GXPayTypeHeader loadXibView];
        _header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 220.f);
    }
    return _header;
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"支付方式"];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"返回白色"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回白色"] forState:UIControlStateHighlighted];
    button.hxn_size = CGSizeMake(44, 44);
    // 让按钮内部的所有内容左对齐
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [button addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXPayTypeCell class]) bundle:nil] forCellReuseIdentifier:PayTypeCell];
    
    self.tableView.tableHeaderView = self.header;
}
#pragma mark -- 点击事件
-(void)backClicked
{
    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"确认放弃支付吗？" message:@"超过订单支付时效后，订单将被取消，请尽快完成支付" constantWidth:HX_SCREEN_WIDTH - 50*2];
    hx_weakify(self);
    zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"放弃" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
        if (strongSelf.isOrderPush) {
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            GXOrderDetailVC *dvc = [GXOrderDetailVC new];
            dvc.oid = strongSelf.oid;
            [strongSelf.navigationController pushViewController:dvc animated:YES];
        }
    }];
    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"继续支付" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
    }];
    cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    okButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
    [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
    self.zh_popupController = [[zhPopupController alloc] init];
    [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
}
- (IBAction)sureClicked:(UIButton *)sender {
    if (!self.selectPayType) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择支付方式"];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"order_no"] = self.order_no;//商品订单id
    parameters[@"pay_type"] = self.selectPayType.payType;//支付方式：1支付宝；2微信支付；3线下支付(后台审核)；4银联支付

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"orderPay" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            //pay_type 支付方式：1支付宝；2微信支付；3线下支付(后台审核)
            if ([strongSelf.selectPayType.payType isEqualToString:@"1"]) {
                [strongSelf doAliPay:responseObject[@"data"]];
            }else if ([strongSelf.selectPayType.payType isEqualToString:@"2"]){
                [strongSelf doWXPay:[responseObject[@"data"] dictionaryWithJsonString]];
            }else if ([strongSelf.selectPayType.payType isEqualToString:@"3"]){
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
                // 跳转支付结果页面
                GXPayResultVC *rvc = [GXPayResultVC new];
                rvc.orderPay = strongSelf.orderPay;
                rvc.pay_type = strongSelf.selectPayType.payType;
                [strongSelf.navigationController pushViewController:rvc animated:YES];
            }else{
                // 银联支付
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
// 支付宝支付
-(void)doAliPay:(NSString *)parameters
{
    NSString *appScheme = @"GXAliPay";
    // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = parameters;
    
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultStatus"] intValue] == 9000) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"支付成功"];
        }else if ([resultDic[@"resultStatus"] intValue] == 6001){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"用户中途取消"];
        }else if ([resultDic[@"resultStatus"] intValue] == 6002){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"网络连接出错"];
        }else if ([resultDic[@"resultStatus"] intValue] == 4000){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"订单支付失败"];
        }
    }];
}
// 微信支付
-(void)doWXPay:(NSDictionary *)dict
{
    if([WXApi isWXAppInstalled]) { // 判断 用户是否安装微信

        //需要创建这个支付对象
        PayReq *req   = [[PayReq alloc] init];
        //由用户微信号和AppID组成的唯一标识，用于校验微信用户
        req.openID = dict[@"appid"];
        
        // 商家id，在注册的时候给的
        req.partnerId = dict[@"partnerid"];
        
        // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
        req.prepayId  = dict[@"prepayid"];
        
        // 根据财付通文档填写的数据和签名
        //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
        req.package   = dict[@"package"];
        
        // 随机编码，为了防止重复的，在后台生成
        req.nonceStr  = dict[@"noncestr"];
        
        // 这个是时间戳，也是在后台生成的，为了验证支付的
        req.timeStamp = [dict[@"timestamp"] intValue];
        
        // 这个签名也是后台做的
        req.sign = dict[@"sign"];
        
        //发送请求到微信，等待微信返回onResp
        [WXApi sendReq:req];
    }else{
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"未安装微信"];
    }
}
#pragma mark -- 支付回调处理
-(void)doPayPush:(NSNotification *)note
{
    if ([note.userInfo[@"result"] isEqualToString:@"1"]) {//支付成功
        //1成功 2取消支付 3支付失败
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"支付成功"];
        // 跳转支付结果页面
        GXPayResultVC *rvc = [GXPayResultVC new];
        rvc.orderPay = self.orderPay;
        rvc.pay_type = self.selectPayType.payType;
        [self.navigationController pushViewController:rvc animated:YES];
    }else {
        if([note.userInfo[@"result"] isEqualToString:@"2"]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"取消支付"];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"支付失败"];
        }
        if (self.isOrderPush) {// 订单列表或者订单详情跳转
            
        }else{
            GXOrderDetailVC *dvc = [GXOrderDetailVC new];
            dvc.oid = self.oid;
            [self.navigationController pushViewController:dvc animated:YES];
        }
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -- 接口请求
-(void)getPayOrderDataRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"oid"] = self.oid;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"getPayOrderData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.orderPay = [GXOrderPay yy_modelWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.header.orderPay = strongSelf.orderPay;
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
    return self.payTypes.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXPayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:PayTypeCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GXPayType *payType = self.payTypes[indexPath.row];
    cell.payType = payType;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 50.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GXPartnerDataSectionHeader *header = [GXPartnerDataSectionHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44.f);
    header.titleLabel.text = @"选择支付方式";
    header.moreTitle.hidden = YES;
    
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXPayType *payType = self.payTypes[indexPath.row];
    
    self.selectPayType.isSelected = NO;
    payType.isSelected = YES;
    
    self.selectPayType = payType;
    
    [tableView reloadData];
}

@end
