//
//  GXSaleMaterialChildVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXSaleMaterialChildVC.h"
#import "GXGoodsMaterialCell.h"
#import "GXGoodsMaterialLayout.h"
#import "GXSaleMaterialHeader.h"
#import "GXMaterialFilter.h"
#import "GXTopSaleMaterial.h"
#import "GXSaleMaterialFilerView.h"
#import "GXAllMaterialVC.h"
#import "GXGoodsDetailVC.h"
#import "GXSaveImageToPHAsset.h"
#import "GXShareView.h"
#import <zhPopupController.h>
#import <UMShare/UMShare.h>

@interface GXSaleMaterialChildVC ()<UITableViewDelegate,UITableViewDataSource,GXGoodsMaterialCellDelegate,GXSaleMaterialFilerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SPButton *filterBtn;
/* 头视图 */
@property(nonatomic,strong) GXSaleMaterialHeader *header;
/* 筛选视图 */
@property(nonatomic,strong) GXSaleMaterialFilerView *filterView;
/* 顶部素材 */
@property(nonatomic,strong) NSArray *topMaterials;
/* 素材筛选 */
@property(nonatomic,strong) GXMaterialFilter *materialFilter;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 列表 */
@property(nonatomic,strong) NSMutableArray *materialLayouts;
/* 1控区控价 2全部*/
@property(nonatomic,copy) NSString *control;
/* 商品分类筛选id */
@property(nonatomic,copy) NSString *catalog_id;
/* 宣传分类筛选id */
@property(nonatomic,copy) NSString *advertise_id;
/* 卖货方案分类id */
@property(nonatomic,copy) NSString *plan_id;
/** 分享数据模型 */
@property (nonatomic,strong) GXGoodsMaterialLayout *shareModel;
/* 分享弹框 */
@property (nonatomic, strong) zhPopupController *sharePopVC;
@end

@implementation GXSaleMaterialChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.control = @"2";
    [self setUpTableView];
    [self setUpRefresh];
    [self startShimmer];
    [self getMaterialFilterDataRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.view.hxn_width = HX_SCREEN_WIDTH;
}
-(NSMutableArray *)materialLayouts
{
    if (_materialLayouts == nil) {
        _materialLayouts = [NSMutableArray array];
    }
    return _materialLayouts;
}
-(GXSaleMaterialHeader *)header
{
    if (_header == nil) {
        _header = [GXSaleMaterialHeader  loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 80.f);
    }
    return _header;
}
-(GXSaleMaterialFilerView *)filterView
{
    if (_filterView == nil) {
        _filterView = [[GXSaleMaterialFilerView alloc] init];
        _filterView.delegate = self;
        _filterView.titleColor = UIColorFromRGB(0x131D2D);
        _filterView.titleHightLightColor = HXControlBg;
    }
    return _filterView;
}
#pragma mark -- 视图相关
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
    
    hx_weakify(self);
    [self.tableView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
        [weakSelf startShimmer];
        [weakSelf getMaterialListDataRequest:YES completedCall:^{
            [weakSelf.tableView reloadData];
        }];
    }];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getMaterialListDataRequest:YES completedCall:^{
            [strongSelf.tableView reloadData];
        }];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getMaterialListDataRequest:NO completedCall:^{
            [strongSelf.tableView reloadData];
        }];
    }];
}
#pragma mark -- 点击事件
- (IBAction)controlClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        [sender setBackgroundColor:HXControlBg];
        self.control = @"1";
    }else{
        [sender setBackgroundColor:UIColorFromRGB(0xF3F3F3)];
        self.control = @"2";
    }
    hx_weakify(self);
    [self getMaterialListDataRequest:YES completedCall:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView reloadData];
    }];
}
- (IBAction)filterClicked:(SPButton *)sender {
    if (self.filterView.show) {
        [self.filterView menuHidden];
        return;
    }
    
    self.filterBtn.selected = YES;
    self.filterBtn.backgroundColor = HXControlBg;
    
    self.filterView.dataSource = self.materialFilter;
    
    [self.filterView menuShowInSuperView:nil];
}
#pragma mark -- GYBrandMenuViewDelegate
//出现位置
- (CGPoint)filterMenu_positionInSuperView
{
    return CGPointMake(0, self.HXNavBarHeight + 44.f + 50.f);
}
//消失
- (void)filterMenu_didDismiss
{
    self.filterBtn.selected = NO;
    self.filterBtn.backgroundColor = UIColorFromRGB(0xF3F3F3);
}
//点击事件
- (void)filterMenu:(GXSaleMaterialFilerView *)menu didSelectLogId:(NSString *)logId didSelectAdvertiseId:(NSString *)advertiseId didSelectPlanId:(NSString *)planId
{
    self.catalog_id = logId;
    self.advertise_id = advertiseId;
    self.plan_id = planId;
    
    hx_weakify(self);
    [self getMaterialListDataRequest:YES completedCall:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView reloadData];
    }];
}
#pragma mark -- 接口请求
-(void)getMaterialFilterDataRequest
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 执行循序1
    hx_weakify(self);
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        
        [HXNetworkTool POST:HXRC_M_URL action:@"admin/materialGood" parameters:@{} success:^(id responseObject) {
            if([[responseObject objectForKey:@"status"] integerValue] == 1) {
                strongSelf.topMaterials = [NSArray yy_modelArrayWithClass:[GXTopSaleMaterial class] json:responseObject[@"data"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        
        [HXNetworkTool POST:HXRC_M_URL action:@"admin/materialData" parameters:@{} success:^(id responseObject) {
            if([[responseObject objectForKey:@"status"] integerValue] == 1) {
                strongSelf.materialFilter = [GXMaterialFilter yy_modelWithDictionary:responseObject[@"data"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    // 执行循序2
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        [strongSelf getMaterialListDataRequest:YES completedCall:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        // 执行顺序10
        hx_strongify(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf stopShimmer];
            [strongSelf handleMaterialData];
        });
    });
}
-(void)getMaterialListDataRequest:(BOOL)isRefresh completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"material_title"] = @"";//货素材标题搜索 没有则不传或者传""
    parameters[@"top"] = @(self.dataType);//为1表示筛选全部 为2表示筛选购买过 为3表示筛选转发过 根据素材名称搜索时没有该字段则不传或者传""
    parameters[@"control"] = self.control;//为1表示筛选控区控价 为2表示筛选全部 没有该字段则不传或者传""
    parameters[@"catalog_id"] = (self.catalog_id && self.catalog_id.length)?self.catalog_id:@"";//根据商品分类筛选卖货素材
    parameters[@"advertise_id"] = (self.advertise_id && self.advertise_id.length)?self.advertise_id:@"";//根据宣传分类筛选卖货素材
    parameters[@"plan_id"] = (self.plan_id && self.plan_id.length)?self.plan_id:@"";//根据卖货方案分类id筛选卖货素材
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/materialList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;

                [strongSelf.materialLayouts removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXGoodsMaterial class] json:responseObject[@"data"]];
                for (GXGoodsMaterial *material in arrt) {
                    GXGoodsMaterialLayout *layout = [[GXGoodsMaterialLayout alloc] initWithModel:material];
                    [strongSelf.materialLayouts addObject:layout];
                }
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;

                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXGoodsMaterial class] json:responseObject[@"data"]];
                    for (GXGoodsMaterial *material in arrt) {
                        GXGoodsMaterialLayout *layout = [[GXGoodsMaterialLayout alloc] initWithModel:material];
                        [strongSelf.materialLayouts addObject:layout];
                    }
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
        if (completedCall) {
            completedCall();
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        if (completedCall) {
            completedCall();
        }
    }];
}
-(void)handleMaterialData
{
    self.tableView.hidden = NO;
    
    if (self.topMaterials && self.topMaterials.count) {
        self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 80.f);
        self.tableView.tableHeaderView = self.header;
        self.header.topMaterials = self.topMaterials;
        
        hx_weakify(self);
        self.header.materialClickedCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            GXTopSaleMaterial *material = strongSelf.topMaterials[index];
            GXAllMaterialVC *mvc = [GXAllMaterialVC new];
            mvc.material_catalog_id = material.material_filter_id;
            mvc.navTitle = material.material_filter_name;
            [strongSelf.navigationController pushViewController:mvc animated:YES];
        };
    }
    
    [self.tableView reloadData];
}
-(void)shareNumRequest:(NSString *)material_id
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"material_id"] = material_id;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/shareMaterial" parameters:parameters success:^(id responseObject) {
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
#pragma mark -- TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.materialLayouts.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXGoodsMaterialLayout *layout = self.materialLayouts[indexPath.row];
    return layout.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXGoodsMaterialCell * cell = [GXGoodsMaterialCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.targetVc = self;
    GXGoodsMaterialLayout *layout = self.materialLayouts[indexPath.row];
    cell.materialLayout = layout;
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -- GXGoodsMaterialCellDelegate
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
            [savePh saveImages:Cell.materialLayout.material.photos comletedCall:^{
                // 复制文本
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = Cell.materialLayout.material.dsp;
                    if (Cell.materialLayout.material.photos.count > 1) {
                        [strongSelf showShareView:YES];
                    }else{
                        [strongSelf showShareView:NO];
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
