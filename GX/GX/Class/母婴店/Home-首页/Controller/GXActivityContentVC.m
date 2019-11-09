//
//  GXActivityContentVC.m
//  GX
//
//  Created by 夏增明 on 2019/11/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXActivityContentVC.h"
#import <WebKit/WebKit.h>
#import "GXActivity.h"
#import "GXGoodsDetailVC.h"

@interface GXActivityContentVC ()
@property (nonatomic, strong) WKWebView  *webView;
@property (weak, nonatomic) IBOutlet UIImageView *m_cover_img;
@property (weak, nonatomic) IBOutlet UILabel *m_title;

@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *good_name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *sale_num;
@property (weak, nonatomic) IBOutlet UIView *webContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webContentViewHeight;
/* 活动详情 */
@property(nonatomic,strong) GXActivity *activity;
@end

@implementation GXActivityContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"活动详情"];

    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.webContentView addSubview:self.webView];
    [self startShimmer];
    [self getPromoteActDetailRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.webView.frame = self.webContentView.bounds;
}
- (WKWebView *)webView{
    if (_webView == nil) {
        _webView = [[WKWebView alloc] initWithFrame:self.webContentView.bounds configuration:[WKWebViewConfiguration new]];
        _webView.scrollView.scrollEnabled = NO;
        [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return _webView;
}
-(void)getPromoteActDetailRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"material_id"] = self.material_id;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/promoteActDetail" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.activity = [GXActivity yy_modelWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleActivityDetail];
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
-(void)handleActivityDetail
{
    [self.m_cover_img sd_setImageWithURL:[NSURL URLWithString:self.activity.m_cover_img]];
    [self.m_title setTextWithLineSpace:5. withString:self.activity.material_title withFont:[UIFont systemFontOfSize:13]];
    
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:self.activity.cover_img]];
    self.good_name.text = self.activity.goods_name;
    if ([self.activity.control_type isEqualToString:@"1"]) {
        self.price.text = [NSString stringWithFormat:@"￥%@-￥%@",self.activity.min_price,self.activity.max_price];
    }else{
        self.price.text = [NSString stringWithFormat:@"￥%@",self.activity.min_price];
    }
    self.sale_num.text = [NSString stringWithFormat:@"剩余：%@",self.activity.stock];
    
    NSString *html5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:15px 15px;}</style></head><body>%@</body></html>",self.activity.material_desc];
    [self.webView loadHTMLString:html5 baseURL:[NSURL URLWithString:HXRC_URL_HEADER]];
}
- (IBAction)goodsClicked:(UIButton *)sender {
    GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
    dvc.goods_id = self.activity.goods_id;
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark -- 事件监听
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.webView.hxn_height = self.webView.scrollView.contentSize.height;
        self.webContentViewHeight.constant = self.webView.scrollView.contentSize.height + 50.f;
    }
}
-(void)dealloc
{
    @try {
        [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    }
    @catch (NSException *exception) {
        HXLog(@"多次删除了");
    }
    @finally {
        HXLog(@"多次删除了");
    }
}
@end
