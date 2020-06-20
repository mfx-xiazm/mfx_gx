//
//  GXAllMaterialVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXAllMaterialVC.h"
#import "GXGoodsMaterialCell.h"
#import "GXGoodsMaterialLayout.h"
#import "HXSearchBar.h"
#import "GXGoodsDetailVC.h"
#import "GXSaveImageToPHAsset.h"
#import "GXShareView.h"
#import <zhPopupController.h>
#import <UMShare/UMShare.h>
#import "zhAlertView.h"

@interface GXAllMaterialVC ()<UITableViewDelegate,UITableViewDataSource,GXGoodsMaterialCellDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 布局数组 */
@property (nonatomic,strong) NSMutableArray *layoutsArr;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 分享数据模型 */
@property (nonatomic,strong) GXGoodsMaterialLayout *shareModel;
/* 分享弹框 */
@property (nonatomic, strong) zhPopupController *sharePopVC;
@end

@implementation GXAllMaterialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpRefresh];
    if (!self.isSearch) {
        [self startShimmer];
        [self getMaterialListDataRequest:YES];
    }
}
-(NSMutableArray *)layoutsArr
{
    if (!_layoutsArr) {
        _layoutsArr = [NSMutableArray array];
    }
    return _layoutsArr;
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    if (self.isSearch) {
        [self.navigationItem setTitle:nil];

        HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH - 70.f, 30.f)];
        searchBar.backgroundColor = [UIColor whiteColor];
        searchBar.layer.cornerRadius = 15.f;
        searchBar.layer.masksToBounds = YES;
        searchBar.delegate = self;
        searchBar.placeholder = @"请输入素材名称查询";
        self.searchBar = searchBar;
        self.navigationItem.titleView = searchBar;
    }else{
        [self.navigationItem setTitle:self.navTitle?self.navTitle:@"全部素材"];
    }
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getMaterialListDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getMaterialListDataRequest:NO];
    }];
}
-(void)getMaterialListDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.goods_id && self.goods_id.length) {
        parameters[@"goods_id"] = self.goods_id;//商品id
    }else{
        parameters[@"material_title"] = [self.searchBar hasText]?self.searchBar.text:@"";//货素材标题搜索 没有则不传或者传""
        parameters[@"material_catalog_id"] = (self.material_catalog_id && self.material_catalog_id.length)?self.material_catalog_id:@"";
    }
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:(self.goods_id && self.goods_id.length)?@"program/getGoodMaterial":@"program/materialList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                
                [strongSelf.layoutsArr removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXGoodsMaterial class] json:responseObject[@"data"]];
                for (GXGoodsMaterial *material in arrt) {
                    GXGoodsMaterialLayout *layout = [[GXGoodsMaterialLayout alloc] initWithModel:material];
                    [strongSelf.layoutsArr addObject:layout];
                }
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXGoodsMaterial class] json:responseObject[@"data"]];
                    for (GXGoodsMaterial *material in arrt) {
                        GXGoodsMaterialLayout *layout = [[GXGoodsMaterialLayout alloc] initWithModel:material];
                        [strongSelf.layoutsArr addObject:layout];
                    }
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)shareNumRequest:(NSString *)material_id
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"material_id"] = material_id;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"program/shareMaterial" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.shareModel.material.share_num = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
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
#pragma mark -- UITextField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self getMaterialListDataRequest:YES];
    return YES;
}
#pragma mark -- TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.layoutsArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXGoodsMaterialLayout *layout = self.layoutsArr[indexPath.row];
    return layout.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXGoodsMaterialCell * cell = [GXGoodsMaterialCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.targetVc = self;
    GXGoodsMaterialLayout *layout = self.layoutsArr[indexPath.row];
    cell.materialLayout = layout;
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma arguments/** 评价 */
/** 点击了全文/收回 */
- (void)didClickMoreLessInCell:(GXGoodsMaterialCell *)Cell
{
    GXGoodsMaterialLayout *layout = Cell.materialLayout;
    layout.material.isOpening = !layout.material.isOpening;
    
    [layout resetLayout];
    [self.tableView reloadData];
}
/** 查看商品 */
- (void)didClickGoodsInCell:(GXGoodsMaterialCell *)Cell
{
    GXGoodsMaterial *material = Cell.materialLayout.material;
    GXGoodsDetailVC *dvc = [GXGoodsDetailVC new];
    dvc.goods_id = material.goods_id;
    [self.navigationController pushViewController:dvc animated:YES];
}
/** 分享 */
- (void)didClickShareInCell:(GXGoodsMaterialCell *)Cell
{
    //HXLog(@"分享");
    self.shareModel = Cell.materialLayout;
    if (Cell.materialLayout.material.photos && Cell.materialLayout.material.photos.count) {
        [MBProgressHUD showLoadToView:nil title:@"图片处理中..."];
        hx_weakify(self);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            hx_strongify(weakSelf);
            GXSaveImageToPHAsset *savePh = [[GXSaveImageToPHAsset alloc] init];
            savePh.targetVC = strongSelf;
            [savePh saveImages:Cell.materialLayout.material.photos comletedCall:^(NSInteger result) {
                // 复制文本
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                    if (result != 0) {
                        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                        pasteboard.string = Cell.materialLayout.material.dsp;
                        
                        if (Cell.materialLayout.material.photos.count > 1) {
                            [strongSelf showShareView:YES];
                        }else{
                            [strongSelf showShareView:NO];
                        }
                    }else{
                        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相册权限" message:@"设置-隐私-相册" constantWidth:HX_SCREEN_WIDTH - 50*2];
                        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                            [strongSelf.sharePopVC dismiss];
                            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];//跳转到本应用的设置页面
                            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                [[UIApplication sharedApplication] openURL:url];
                            }
                        }];
                        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                        [alert addAction:okButton];
                        strongSelf.sharePopVC = [[zhPopupController alloc] initWithView:alert size:alert.bounds.size];
                        [strongSelf.sharePopVC show];
                    }
                });
            }];
        });
    }else{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = Cell.materialLayout.material.dsp;
        
        [self showShareView:NO];
    }
}
-(void)showShareView:(BOOL)isMorePicture
{
    GXShareView *share  = [GXShareView loadXibView];
    share.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 400.f);
    if (isMorePicture) {
        share.onlyWxView.hidden = NO;
    }else{
        share.onlyWxView.hidden = YES;
    }
    hx_weakify(self);
    share.shareTypeCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        [strongSelf.sharePopVC dismissWithDuration:0.25 completion:nil];
        if (index != 3) {
            [strongSelf shareNumRequest:strongSelf.shareModel.material.material_id];
            if (index == 0) {// 仅仅打开微信
                NSURL *url = [NSURL URLWithString:@"weixin://"];
                BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
                //先判断是否能打开该url
                if (canOpen) {//打开微信
                    [[UIApplication sharedApplication] openURL:url];
                }else {
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"您的设备未安装微信APP"];
                }
            }else{
                //创建分享消息对象
                NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:strongSelf.shareModel.material.photos.firstObject]];
                UIImage *image = [UIImage imageWithData:data]; // 取得图片
                
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:@"呱选-精品素材" descr:strongSelf.shareModel.material.dsp thumImage:image];
                shareObject.shareImage = image;
                messageObject.shareObject = shareObject;
                //调用分享接口
                [[UMSocialManager defaultManager] shareToPlatform:index==1?UMSocialPlatformType_WechatTimeLine:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                    if (error) {
                        UMSocialLogInfo(@"************Share fail with error %@*********",error);
                        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
                    }else{
                        if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                            UMSocialShareResponse *resp = data;
                            //分享结果消息
                            UMSocialLogInfo(@"response message is %@",resp.message);
                            //第三方原始返回的数据
                            UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                        }else{
                            UMSocialLogInfo(@"response data is %@",data);
                        }
                    }
                }];
            }
        }
    };
    self.sharePopVC = [[zhPopupController alloc] initWithView:share size:share.bounds.size];
    self.sharePopVC.layoutType = zhPopupLayoutTypeBottom;
    [self.sharePopVC show];
}
@end
