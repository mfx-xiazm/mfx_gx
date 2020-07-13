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
#import "GXMyOrder.h"
#import "GXWebContentVC.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "GXMyRefund.h"
#import "GXUpOrderVC.h"
#import "GXPayTypeVC.h"
#import "GXPayResultVC.h"
#import "GXGoodsDetailVC.h"
#import "GXMyOrderFooter.h"
#import "GXShopGoodsCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GXHomeSectionHeader.h"
#import "GXUpMoneyProofVC.h"
#import "GXShowMoneyProofVC.h"
#import "GXApplyRefundVC.h"
#import "GXGiftGoodsDetailVC.h"

static NSString *const UpOrderGoodsCell = @"UpOrderGoodsCell";
static NSString *const ShopGoodsCell = @"ShopGoodsCell";
static NSString *const HomeSectionHeader = @"HomeSectionHeader";

@interface GXOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
/* 头视图 */
@property(nonatomic,strong) GXOrderDetailHeader *header;
/* 退款状态尾部视图 */
@property(nonatomic,strong) GXRefundDetailFooter *footer;
/* 订单详情 */
@property(nonatomic,strong) GXMyOrder *orderDetail;
/* 退款详情 */
@property(nonatomic,strong) GXMyRefund *refundDetail;
/* 订单操作视图 */
@property (weak, nonatomic) IBOutlet UIView *handleView;
/* 订单操作视图高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *handleViewHeight;
/* 订单操作第一个按钮 */
@property (weak, nonatomic) IBOutlet UIButton *firstHandleBtn;
/* 订单操作第二个按钮 */
@property (weak, nonatomic) IBOutlet UIButton *secondHandleBtn;
/* 订单操作第三个按钮 */
@property (weak, nonatomic) IBOutlet UIButton *thirdHandleBtn;
/** vc控制器 */
@property (nonatomic,strong) NSMutableArray *controllers;
/* 提示框 */
@property (nonatomic, strong) zhPopupController *alertPopVC;
@end

@implementation GXOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:(self.refund_id && self.refund_id.length)?@"退款详情":@"订单详情"];
    hx_weakify(self);
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[GXUpOrderVC class]] || [obj isKindOfClass:[GXPayTypeVC class]] || [obj isKindOfClass:[GXPayResultVC class]]) {
            hx_strongify(weakSelf);
            [strongSelf.controllers removeObjectAtIndex:idx];
        }
    }];
    [self.navigationController setViewControllers:self.controllers];
    self.contentScrollView.hidden = YES;
    [self setUpTableView];
    [self setUpCollectionView];
    [self startShimmer];
    [self getOrderInfoRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 275);
    self.footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 135);
}
- (NSMutableArray *)controllers {
    if (!_controllers) {
        _controllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    }
    return _controllers;
}
-(GXOrderDetailHeader *)header
{
    if (_header == nil) {
        _header = [GXOrderDetailHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 275);
    }
    return _header;
}
-(GXRefundDetailFooter *)footer
{
    if (_footer == nil) {
        _footer = [GXRefundDetailFooter loadXibView];
        _footer.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 135);
    }
    return _footer;
}
-(void)setUpTableView
{
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXUpOrderGoodsCell class]) bundle:nil] forCellReuseIdentifier:UpOrderGoodsCell];
    
    self.tableView.tableHeaderView = self.header;
}
-(void)setUpCollectionView
{
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = NO;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXShopGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:ShopGoodsCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXHomeSectionHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeSectionHeader];
}
#pragma mark -- 接口请求
-(void)getOrderInfoRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.refund_id && self.refund_id.length) {
        parameters[@"refund_id"] = self.refund_id;
    }else{
        parameters[@"oid"] = self.oid;
    }
    NSString *action = nil;
    if ([[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"1"]) {//母婴店
        action = (self.refund_id && self.refund_id.length)?@"admin/orderRefundInfo":@"admin/getOrderInfo";
    }else if ([[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"2"]) {//供应商
        action = (self.refund_id && self.refund_id.length)?@"index/orderRefundInfo":@"index/getOrderInfo";
    }else{
        action = @"program/getOrderInfo";
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:action parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (strongSelf.refund_id && strongSelf.refund_id.length) {
                strongSelf.refundDetail = [GXMyRefund yy_modelWithDictionary:responseObject[@"data"]];
            }else{
                strongSelf.orderDetail = [GXMyOrder yy_modelWithDictionary:responseObject[@"data"]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleOrderDetailData];
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
-(void)handleOrderDetailData
{
    if (self.refund_id && self.refund_id.length) {
        self.refundDetail.isRefundDetail = YES;
    }else{
        self.orderDetail.isDetailOrder = YES;
    }
    
    if ([[MSUserManager sharedInstance].curUserInfo.utype isEqualToString:@"1"]) {//母婴店
        if (self.refund_id && self.refund_id.length) {
            if ([self.refundDetail.refund_status isEqualToString:@"4"] || [self.refundDetail.refund_status isEqualToString:@"6"]) {
                self.handleView.hidden = NO;
                self.handleViewHeight.constant = 50.f;
                
                self.firstHandleBtn.hidden = YES;
                self.secondHandleBtn.hidden = YES;
                
                self.thirdHandleBtn.hidden = NO;
                [self.thirdHandleBtn setTitle:@"查看原因" forState:UIControlStateNormal];
                self.thirdHandleBtn.backgroundColor = [UIColor whiteColor];
                self.thirdHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                [self.thirdHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                self.handleView.hidden = YES;
                self.handleViewHeight.constant = 0.f;
                self.firstHandleBtn.hidden = YES;
                self.secondHandleBtn.hidden = YES;
                self.thirdHandleBtn.hidden = YES;
            }
            
            self.header.refundDetail = self.refundDetail;
            hx_weakify(self);
            self.header.lookLogisCall = ^{
                hx_strongify(weakSelf);
                //HXLog(@"查看物流");
                GXWebContentVC *cvc = [GXWebContentVC new];
                cvc.navTitle = @"物流详情";
                cvc.isNeedRequest = NO;
                cvc.url = strongSelf.refundDetail.url;
                [strongSelf.navigationController pushViewController:cvc animated:YES];
            };
            self.header.lookGiftOrderCall = ^{
                hx_strongify(weakSelf);
                //HXLog(@"赠品订单");
                GXGiftGoodsDetailVC *gvc = [GXGiftGoodsDetailVC new];
                gvc.gift_order_id = strongSelf.refundDetail.gift_order_id;
                [strongSelf.navigationController pushViewController:gvc animated:YES];
            };
            
            if (self.refundDetail.address) {
                self.footer.refundDetail = self.refundDetail;// 退款地址
                self.tableView.tableFooterView = self.footer;
            }
                
        }else{
            if ([self.orderDetail.status isEqualToString:@"待付款"]) {
                self.handleView.hidden = NO;
                self.handleViewHeight.constant = 50.f;
                
                self.firstHandleBtn.hidden = YES;
                
                self.secondHandleBtn.hidden = NO;
                [self.secondHandleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                self.secondHandleBtn.backgroundColor = [UIColor whiteColor];
                self.secondHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                [self.secondHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                self.thirdHandleBtn.hidden = NO;
                [self.thirdHandleBtn setTitle:@"立即支付" forState:UIControlStateNormal];
                self.thirdHandleBtn.backgroundColor = HXControlBg;
                self.thirdHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
                [self.thirdHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            }else if ([self.orderDetail.status isEqualToString:@"待发货"]) {
                if ([self.orderDetail.pay_type isEqualToString:@"3"]) {// 线下付款
                    /**线下支付审核状态：1待上传打款凭证；2审核通过；3审核驳回。4上传打款凭证审核中；线上支付不需要审核逻辑*/
                    if ([self.orderDetail.approve_status isEqualToString:@"2"]) {//订单审核通过
                        self.handleView.hidden = NO;
                        self.handleViewHeight.constant = 50.f;
                        
                        self.firstHandleBtn.hidden = YES;
                        self.secondHandleBtn.hidden = YES;
                        
                        self.thirdHandleBtn.hidden = NO;
                        [self.thirdHandleBtn setTitle:@"售后退款" forState:UIControlStateNormal];
                        self.thirdHandleBtn.backgroundColor = [UIColor whiteColor];
                        self.thirdHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                        [self.thirdHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }else if ([self.orderDetail.approve_status isEqualToString:@"3"]) {
                        self.handleView.hidden = YES;
                        self.handleViewHeight.constant = 0.f;
                        
                        self.firstHandleBtn.hidden = YES;
                        self.secondHandleBtn.hidden = YES;
                        self.thirdHandleBtn.hidden = YES;
                    }else{
                        self.handleView.hidden = NO;
                        self.handleViewHeight.constant = 50.f;
                         
                        self.firstHandleBtn.hidden = YES;
                        self.secondHandleBtn.hidden = YES;
                        self.thirdHandleBtn.hidden = NO;
                        // 判断是否已上传打款凭证
                        if ([self.orderDetail.approve_status isEqualToString:@"1"]) {
                            // 没有上传打款凭证
                            [self.thirdHandleBtn setTitle:@"上传凭证" forState:UIControlStateNormal];
                        }else{
                            // 已经上传打款凭证
                            [self.thirdHandleBtn setTitle:@"查看凭证" forState:UIControlStateNormal];
                        }
                        self.thirdHandleBtn.backgroundColor = HXControlBg;
                        self.thirdHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
                        [self.thirdHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                }else{
                    self.handleView.hidden = NO;
                    self.handleViewHeight.constant = 50.f;
                    
                    self.firstHandleBtn.hidden = YES;
                    self.secondHandleBtn.hidden = YES;
                    
                    self.thirdHandleBtn.hidden = NO;
                    [self.thirdHandleBtn setTitle:@"售后退款" forState:UIControlStateNormal];
                    self.thirdHandleBtn.backgroundColor = [UIColor whiteColor];
                    self.thirdHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                    [self.thirdHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
            }else if ([self.orderDetail.status isEqualToString:@"待收货"]) {
                self.handleView.hidden = NO;
                self.handleViewHeight.constant = 50.f;
                
                self.firstHandleBtn.hidden = NO;
                [self.firstHandleBtn setTitle:@"售后退款" forState:UIControlStateNormal];
                self.firstHandleBtn.backgroundColor = [UIColor whiteColor];
                self.firstHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                [self.firstHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                self.secondHandleBtn.hidden = NO;
                [self.secondHandleBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                self.secondHandleBtn.backgroundColor = [UIColor whiteColor];
                self.secondHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                [self.secondHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                self.thirdHandleBtn.hidden = NO;
                [self.thirdHandleBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                self.thirdHandleBtn.backgroundColor = HXControlBg;
                self.thirdHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
                [self.thirdHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else if ([self.orderDetail.status isEqualToString:@"待评价"]) {
                self.handleView.hidden = NO;
                self.handleViewHeight.constant = 50.f;
                
                self.firstHandleBtn.hidden = YES;
                
                self.thirdHandleBtn.hidden = NO;
                [self.thirdHandleBtn setTitle:@"评价" forState:UIControlStateNormal];
                self.thirdHandleBtn.backgroundColor = HXControlBg;
                self.thirdHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
                [self.thirdHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                if ([self.orderDetail.isRefund isEqualToString:@"1"]) {
                    self.secondHandleBtn.hidden = NO;
                    [self.secondHandleBtn setTitle:@"售后退款" forState:UIControlStateNormal];
                    self.secondHandleBtn.backgroundColor = [UIColor whiteColor];
                    self.secondHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                    [self.secondHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }else{
                    self.secondHandleBtn.hidden = YES;
                }
            }else{
                self.handleView.hidden = NO;
                self.handleViewHeight.constant = 50.f;
                
                self.firstHandleBtn.hidden = YES;
                
                self.thirdHandleBtn.hidden = NO;
                [self.thirdHandleBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                self.thirdHandleBtn.backgroundColor = [UIColor whiteColor];
                self.thirdHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                [self.thirdHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                if ([self.orderDetail.isRefund isEqualToString:@"1"]) {
                    self.secondHandleBtn.hidden = NO;
                    [self.secondHandleBtn setTitle:@"售后退款" forState:UIControlStateNormal];
                    self.secondHandleBtn.backgroundColor = [UIColor whiteColor];
                    self.secondHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                    [self.secondHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }else{
                    self.secondHandleBtn.hidden = YES;
                }
            }
            
            self.header.orderDetail = self.orderDetail;
            hx_weakify(self);
            self.header.lookLogisCall = ^{
                hx_strongify(weakSelf);
                //HXLog(@"查看物流");
                GXWebContentVC *cvc = [GXWebContentVC new];
                cvc.navTitle = @"物流详情";
                cvc.isNeedRequest = NO;
                cvc.url = strongSelf.orderDetail.url;
                [strongSelf.navigationController pushViewController:cvc animated:YES];
            };
            self.header.lookGiftOrderCall = ^{
                hx_strongify(weakSelf);
                //HXLog(@"赠品订单");
                GXGiftGoodsDetailVC *gvc = [GXGiftGoodsDetailVC new];
                gvc.gift_order_id = strongSelf.orderDetail.gift_order_id;
                [strongSelf.navigationController pushViewController:gvc animated:YES];
            };
        }
    }else {//供应商或者销售员
        if (self.refund_id && self.refund_id.length) {
            if ([self.refundDetail.refund_status isEqualToString:@"4"] || [self.refundDetail.refund_status isEqualToString:@"6"]) {
                self.handleView.hidden = NO;
                self.handleViewHeight.constant = 50.f;
                
                self.firstHandleBtn.hidden = YES;
                self.secondHandleBtn.hidden = YES;
                
                self.thirdHandleBtn.hidden = NO;
                [self.thirdHandleBtn setTitle:@"查看原因" forState:UIControlStateNormal];
                self.thirdHandleBtn.backgroundColor = [UIColor whiteColor];
                self.thirdHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                [self.thirdHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                self.handleView.hidden = YES;
                self.handleViewHeight.constant = 0.f;
                self.firstHandleBtn.hidden = YES;
                self.secondHandleBtn.hidden = YES;
                self.thirdHandleBtn.hidden = YES;
            }
            
            self.header.refundDetail = self.refundDetail;
            hx_weakify(self);
            self.header.lookLogisCall = ^{
                hx_strongify(weakSelf);
                //HXLog(@"查看物流");
                GXWebContentVC *cvc = [GXWebContentVC new];
                cvc.navTitle = @"物流详情";
                cvc.isNeedRequest = NO;
                cvc.url = strongSelf.refundDetail.url;
                [strongSelf.navigationController pushViewController:cvc animated:YES];
            };
            self.header.lookGiftOrderCall = ^{
                hx_strongify(weakSelf);
                //HXLog(@"赠品订单");
                GXGiftGoodsDetailVC *gvc = [GXGiftGoodsDetailVC new];
                gvc.gift_order_id = strongSelf.refundDetail.gift_order_id;
                [strongSelf.navigationController pushViewController:gvc animated:YES];
            };
            if (self.refundDetail.address) {
                self.footer.refundDetail = self.refundDetail;// 退款地址
                self.tableView.tableFooterView = self.footer;
            }
        }else{
            self.handleView.hidden = YES;
            self.handleViewHeight.constant = 0.f;
            self.firstHandleBtn.hidden = YES;
            self.secondHandleBtn.hidden = YES;
            self.thirdHandleBtn.hidden = YES;
            
            self.header.orderDetail = self.orderDetail;
            hx_weakify(self);
            self.header.lookLogisCall = ^{
                hx_strongify(weakSelf);
                //HXLog(@"查看物流");
                GXWebContentVC *cvc = [GXWebContentVC new];
                cvc.navTitle = @"物流详情";
                cvc.isNeedRequest = NO;
                cvc.url = strongSelf.orderDetail.url;
                [strongSelf.navigationController pushViewController:cvc animated:YES];
            };
            self.header.lookGiftOrderCall = ^{
                hx_strongify(weakSelf);
                //HXLog(@"赠品订单");
                GXGiftGoodsDetailVC *gvc = [GXGiftGoodsDetailVC new];
                gvc.gift_order_id = strongSelf.orderDetail.gift_order_id;
                [strongSelf.navigationController pushViewController:gvc animated:YES];
            };
        }
    }
    [self.tableView reloadData];
    
    [self.collectionView reloadData];
    
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.tableViewHeight.constant = weakSelf.tableView.contentSize.height;
        weakSelf.collectionViewHeight.constant = weakSelf.collectionView.contentSize.height;
        weakSelf.contentScrollView.hidden = NO;
    });
    [self.view layoutIfNeeded];
}
#pragma mark -- 业务逻辑
/** 取消订单 */
-(void)cancelOrderRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"oid"] = self.oid;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/cancelOrder" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (strongSelf.orderHandleCall) {
                strongSelf.orderHandleCall(0);
            }
            [strongSelf getOrderInfoRequest];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/** 确认收货 */
-(void)confirmReceiveGoodRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"oid"] = self.oid;
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/confirmReceiveGood" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
           if (strongSelf.orderHandleCall) {
                strongSelf.orderHandleCall(3);
            }
            [strongSelf getOrderInfoRequest];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)deleteOrderRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"oid"] = self.oid;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/delOrder" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (strongSelf.orderHandleCall) {
                    strongSelf.orderHandleCall(5);
                }
                [strongSelf.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 点击事件
- (IBAction)orderHandleBtnClicked:(UIButton *)sender {
    /** 待付款 - 取消订单、立即付款  待发货 - 申请退款[线下审核未通过 - 无]  待收货 - 申请退款、查看物流、确认收货  待评价 - 评价  已完成/退款列表 - 无 */
    if (self.refund_id && self.refund_id.length) {
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"原因" message:self.refundDetail.reject_reason constantWidth:HX_SCREEN_WIDTH - 50*2];
        hx_weakify(self);
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"我知道了" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.alertPopVC dismiss];
        }];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        [alert addAction:okButton];
        self.alertPopVC = [[zhPopupController alloc] initWithView:alert size:alert.bounds.size];
        [self.alertPopVC show];
    }else{
        if (sender.tag == 1) {
            if ([self.orderDetail.status isEqualToString:@"待收货"]) {
                //HXLog(@"申请退款");
                if (![self.orderDetail.refund_status isEqualToString:@"0"] && ![self.orderDetail.refund_status isEqualToString:@"3"] && ![self.orderDetail.refund_status isEqualToString:@"4"]) {
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"该订单正在申请退款"];
                    return;
                }
                GXApplyRefundVC *rvc = [GXApplyRefundVC new];
                rvc.oid = self.oid;
                hx_weakify(self);
                rvc.refundCall = ^{
                    hx_strongify(weakSelf);
                    if (strongSelf.orderHandleCall) {
                        strongSelf.orderHandleCall(2);
                    }
                };
                [self.navigationController pushViewController:rvc animated:YES];
            }
        }else if (sender.tag == 2){
            if ([self.orderDetail.status isEqualToString:@"待付款"]) {
                //HXLog(@"取消订单");
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要取消订单吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
                hx_weakify(self);
                zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.alertPopVC dismiss];
                }];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确认" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.alertPopVC dismiss];
                    [strongSelf cancelOrderRequest];
                }];
                cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
                self.alertPopVC = [[zhPopupController alloc] initWithView:alert size:alert.bounds.size];
                [self.alertPopVC show];
            }else if ([self.orderDetail.status isEqualToString:@"待收货"]) {
                //HXLog(@"查看物流");
                if (self.orderDetail.logistics_no && self.orderDetail.logistics_no.length) {
                    GXWebContentVC *cvc = [GXWebContentVC new];
                    cvc.navTitle = @"物流详情";
                    cvc.isNeedRequest = NO;
                    cvc.url = self.orderDetail.url;
                    [self.navigationController pushViewController:cvc animated:YES];
                }else{
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请联系快递公司"];
                }
            }else{
                //HXLog(@"售后退款");
                GXApplyRefundVC *rvc = [GXApplyRefundVC new];
                rvc.oid = self.oid;
                hx_weakify(self);
                rvc.refundCall = ^{
                    hx_strongify(weakSelf);
                    if (strongSelf.orderHandleCall) {
                        strongSelf.orderHandleCall(2);
                    }
                };
                [self.navigationController pushViewController:rvc animated:YES];
            }
        }else{
            if ([self.orderDetail.status isEqualToString:@"待付款"]) {
                //HXLog(@"立即付款");
                GXPayTypeVC *pvc = [GXPayTypeVC new];
                pvc.oid = self.orderDetail.oid;
                pvc.order_no = self.orderDetail.order_no;
                pvc.isOrderPush = YES;
                hx_weakify(self);
                pvc.paySuccessCall = ^{
                    hx_strongify(weakSelf);
                    [strongSelf getOrderInfoRequest];
                };
                [self.navigationController pushViewController:pvc animated:YES];
            }else if ([self.orderDetail.status isEqualToString:@"待发货"]) {
                if ([self.orderDetail.pay_type isEqualToString:@"3"]) {// 线下付款
                    /**线下支付审核状态：1待上传打款凭证；2审核通过；3审核驳回。4上传打款凭证审核中；线上支付不需要审核逻辑*/
                    if ([self.orderDetail.approve_status isEqualToString:@"2"]) {//订单审核通过
                        //HXLog(@"申请退款");
                        if (![self.orderDetail.refund_status isEqualToString:@"0"] && ![self.orderDetail.refund_status isEqualToString:@"3"] && ![self.orderDetail.refund_status isEqualToString:@"4"]) {
                            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"该订单正在申请退款"];
                            return;
                        }
                        GXApplyRefundVC *rvc = [GXApplyRefundVC new];
                        rvc.oid = self.oid;
                        hx_weakify(self);
                        rvc.refundCall = ^{
                            hx_strongify(weakSelf);
                            if (strongSelf.orderHandleCall) {
                                strongSelf.orderHandleCall(2);
                            }
                        };
                        [self.navigationController pushViewController:rvc animated:YES];
                    }else if ([self.orderDetail.approve_status isEqualToString:@"3"]) {
                        //HXLog(@"无操作");
                    }else{
                        // 判断是否已上传打款凭证
                        if ([self.orderDetail.approve_status isEqualToString:@"1"]) {
                            // 没有上传打款凭证
                            GXUpMoneyProofVC *uvc = [GXUpMoneyProofVC new];
                            GXMyOrderProvider *provider = self.orderDetail.provider.firstObject;
                            GXMyOrderGoods *goods = provider.goods.firstObject;
                            uvc.goods = goods;
                            uvc.oid = self.oid;
                            hx_weakify(self);
                            uvc.upProofCall = ^{
                                hx_strongify(weakSelf);
                                strongSelf.orderDetail.approve_status = @"4";
                                [strongSelf handleOrderDetailData];
                                if (strongSelf.orderHandleCall) {
                                    strongSelf.orderHandleCall(6);
                                }
                            };
                            [self.navigationController pushViewController:uvc animated:YES];
                        }else{
                            // 已经上传打款凭证
                            GXShowMoneyProofVC *svc = [GXShowMoneyProofVC new];
                            svc.oid = self.oid;
                            [self.navigationController pushViewController:svc animated:YES];
                        }
                    }
                }else{
                    //HXLog(@"申请退款");
                    if (![self.orderDetail.refund_status isEqualToString:@"0"] && ![self.orderDetail.refund_status isEqualToString:@"3"] && ![self.orderDetail.refund_status isEqualToString:@"4"]) {
                        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"该订单正在申请退款"];
                        return;
                    }
                    GXApplyRefundVC *rvc = [GXApplyRefundVC new];
                    rvc.oid = self.oid;
                    hx_weakify(self);
                    rvc.refundCall = ^{
                        hx_strongify(weakSelf);
                        if (strongSelf.orderHandleCall) {
                            strongSelf.orderHandleCall(2);
                        }
                    };
                    [self.navigationController pushViewController:rvc animated:YES];
                }
            }else if ([self.orderDetail.status isEqualToString:@"待收货"]) {
                //HXLog(@"确认收货");
                if (![self.orderDetail.refund_status isEqualToString:@"0"] && ![self.orderDetail.refund_status isEqualToString:@"3"] && ![self.orderDetail.refund_status isEqualToString:@"4"]) {
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"该订单正在申请退款"];
                }else{
                    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要确认收货吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
                    hx_weakify(self);
                    zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                        hx_strongify(weakSelf);
                        [strongSelf.alertPopVC dismiss];
                    }];
                    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确认" handler:^(zhAlertButton * _Nonnull button) {
                        hx_strongify(weakSelf);
                        [strongSelf.alertPopVC dismiss];
                        [strongSelf confirmReceiveGoodRequest];
                    }];
                    cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
                    [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                    okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                    [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                    [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
                    self.alertPopVC = [[zhPopupController alloc] initWithView:alert size:alert.bounds.size];
                    [self.alertPopVC show];
                }
            }else if ([self.orderDetail.status isEqualToString:@"待评价"]) {
                //HXLog(@"评价");
                GXEvaluateVC *evc = [GXEvaluateVC new];
                evc.oid = self.oid;
                hx_weakify(self);
                evc.evaluatSuccessCall = ^{
                    hx_strongify(weakSelf);
                    [strongSelf getOrderInfoRequest];
                    if (strongSelf.orderHandleCall) {
                        strongSelf.orderHandleCall(4);
                    }
                };
                [self.navigationController pushViewController:evc animated:YES];
            }else{
                //HXLog(@"删除订单");
                hx_weakify(self);
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该订单吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.alertPopVC dismiss];
                }];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确认" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.alertPopVC dismiss];
                    [strongSelf deleteOrderRequest];
                }];
                cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
                self.alertPopVC = [[zhPopupController alloc] initWithView:alert size:alert.bounds.size];
                [self.alertPopVC show];
            }
        }
    }
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.refund_id && self.refund_id.length) {//根据实际情况数量要加1，利用最后一组的footer展示优惠信息和物流信息
        return self.refundDetail.provider.count + 1;
    }else{
        return self.orderDetail.provider.count + 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.refund_id && self.refund_id.length) {//根据实际情况数量要加1，利用最后一组的footer展示优惠信息和物流信息
        if (section != self.refundDetail.provider.count) {//不是最后一组
            GXMyRefundProvider *provider = self.refundDetail.provider[section];
            return provider.goods.count;
        }else{//最后一组
            return 0;
        }
    }else{
        if (section != self.orderDetail.provider.count) {//不是最后一组
            GXMyOrderProvider *provider = self.orderDetail.provider[section];
            return provider.goods.count;
        }else{//最后一组
            return 0;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXUpOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:UpOrderGoodsCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.refund_id && self.refund_id.length) {
        if (indexPath.section != self.refundDetail.provider.count) {//不是最后一组
            GXMyRefundProvider *provider = self.refundDetail.provider[indexPath.section];
            GYMyRefundGoods *refundGoods = provider.goods[indexPath.row];
            cell.refundGoods = refundGoods;
        }
    }else{
        if (indexPath.section != self.orderDetail.provider.count) {//不是最后一组
            GXMyOrderProvider *provider = self.orderDetail.provider[indexPath.section];
            GXMyOrderGoods *goods = provider.goods[indexPath.row];
            goods.refund_status = self.orderDetail.refund_status;
            goods.status = self.orderDetail.status;
            cell.goods = goods;
        }
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
    if (self.refund_id && self.refund_id.length) {//根据实际情况数量要加1，利用最后一组的footer展示优惠信息和物流信息
        if (section != self.refundDetail.provider.count) {//不是最后一组
            return 40.f;
        }else{//最后一组
            return CGFLOAT_MIN;
        }
    }else{
        if (section != self.orderDetail.provider.count) {//不是最后一组
            return 40.f;
        }else{//最后一组
            return CGFLOAT_MIN;
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GXMyOrderHeader *header = [GXMyOrderHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 40.f);
    if (self.refund_id && self.refund_id.length) {//根据实际情况数量要加1，利用最后一组的footer展示优惠信息和物流信息
        if (section != self.refundDetail.provider.count) {//不是最后一组
            GXMyRefundProvider *provider = self.refundDetail.provider[section];
            header.refundProvider = provider;
            return header;
        }else{//最后一组
            return nil;
        }
    }else{
        if (section != self.orderDetail.provider.count) {//不是最后一组
            GXMyOrderProvider *provider = self.orderDetail.provider[section];
            header.orderProvider = provider;
            return header;
        }else{//最后一组
            return nil;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.refund_id && self.refund_id.length) {//根据实际情况数量要加1，利用最后一组的footer展示优惠信息和物流信息
        if (section != self.refundDetail.provider.count) {//不是最后一组
            return 160.f;
        }else{//最后一组
            return (self.refundDetail.logistics_com_name && self.refundDetail.logistics_com_name.length)?215.f+85.f:190.f+85.f;
        }
    }else{
        if (section != self.orderDetail.provider.count) {//不是最后一组
            return 160.f;
        }else{//最后一组
            return (self.orderDetail.logistics_com_name && self.orderDetail.logistics_com_name.length)?215:190;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.refund_id && self.refund_id.length) {//根据实际情况数量要加1，利用最后一组的footer展示优惠信息和物流信息
        if (section != self.refundDetail.provider.count) {//不是最后一组
            GXMyOrderFooter *footer = [GXMyOrderFooter loadXibView];
            footer.hxn_size = CGSizeMake(tableView.hxn_width, 160.f);
            GXMyRefundProvider *provider = self.refundDetail.provider[section];
            footer.refundProvider = provider;
            return footer;
        }else{//最后一组
            GXOrderDetailFooter *footer = [GXOrderDetailFooter loadXibView];
            footer.refundDetail = self.refundDetail;
            footer.hxn_size = (self.refundDetail.logistics_com_name && self.refundDetail.logistics_com_name.length)?CGSizeMake(tableView.hxn_width, 215.f):CGSizeMake(tableView.hxn_width, 190.f);
            return footer;
        }
    }else{
        if (section != self.orderDetail.provider.count) {//不是最后一组
            GXMyOrderFooter *footer = [GXMyOrderFooter loadXibView];
            footer.hxn_size = CGSizeMake(tableView.hxn_width, 160.f);
            GXMyOrderProvider *provider = self.orderDetail.provider[section];
            footer.orderStatus = self.orderDetail.status;
            footer.orderProvider = provider;
            return footer;
        }else{//最后一组
            GXOrderDetailFooter *footer = [GXOrderDetailFooter loadXibView];
            footer.orderDetail = self.orderDetail;
            footer.hxn_size = (self.orderDetail.logistics_com_name && self.orderDetail.logistics_com_name.length)?CGSizeMake(tableView.hxn_width, 215.f+85.f):CGSizeMake(tableView.hxn_width, 190.f+85.f);
            return footer;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
//    if (self.refund_id && self.refund_id.length) {
//        GYMyRefundGoods *refundGoods = self.refundDetail.goods[indexPath.row];
//        dvc.goods_id = refundGoods.goods_id;
//    }else{
//        GXMyOrderGoods *goods = self.orderDetail.goods[indexPath.row];
//        dvc.goods_id = goods.goods_id;
//    }
//    [self.navigationController pushViewController:dvc animated:YES];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //为你推荐
    return self.orderDetail.goods_recommend.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    //为你推荐
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    //为你推荐
    return 2;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //为你推荐
    GXShopGoodsCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShopGoodsCell forIndexPath:indexPath];
    if (self.refund_id && self.refund_id.length) {
        GXMyRefundRecommend *refundRecommend = self.refundDetail.goods_recommend[indexPath.item];
        cell.refundRecommend = refundRecommend;
    }else{
        GXMyOrderRecommend *orderRecommend = self.orderDetail.goods_recommend[indexPath.item];
        cell.orderRecommend = orderRecommend;
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(HX_SCREEN_WIDTH, 50.f);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        GXHomeSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeSectionHeader forIndexPath:indexPath];
        //为你推荐
        header.recommendView.hidden = NO;
        header.titleView.hidden = YES;
        
        return header;
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //为你推荐
    GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
    if (self.refund_id && self.refund_id.length) {
        GXMyRefundRecommend *refundRecommend = self.refundDetail.goods_recommend[indexPath.item];
        dvc.goods_id = refundRecommend.goods_id;
    }else{
        GXMyOrderRecommend *orderRecommend = self.orderDetail.goods_recommend[indexPath.item];
        dvc.goods_id = orderRecommend.goods_id;
    }
    [self.navigationController pushViewController:dvc animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //为你推荐
    CGFloat width = (HX_SCREEN_WIDTH-10*3)/2.0;
    CGFloat height = width+70.f;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    //为你推荐
    return 5.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    //为你推荐
    return 5.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //为你推荐
    return  UIEdgeInsetsMake(0.f, 5.f, 15.f, 5.f);
}

@end
