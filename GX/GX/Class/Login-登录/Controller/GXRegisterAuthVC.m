//
//  GXRegisterAuthVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXRegisterAuthVC.h"
#import "GXRegisterAuthHeader.h"
#import "GXRegisterAuthCell.h"
#import "GXRegisterAuthFooter.h"
#import "GXRegisterAddStoreFooter.h"
#import "GXCatalogItem.h"
#import "GXRegisterStore.h"
#import "GXRegion.h"
#import "GXSelectRegion.h"
#import "GXWebContentVC.h"
#import "zhAlertView.h"
#import <zhPopupController.h>

static NSString *const RegisterAuthCell = @"RegisterAuthCell";
@interface GXRegisterAuthVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) GXRegisterAuthHeader *header;
/* 尾视图 */
@property(nonatomic,strong) GXRegisterAuthFooter *footer;
/* 经营类目 */
@property(nonatomic,strong) NSArray *catalogItem;
/* 主门店 */
@property(nonatomic,strong) GXRegisterStore *mainStore;
/* 店铺 */
@property(nonatomic,strong) NSMutableArray *stores;
/* 所有地区 */
@property(nonatomic,strong) GXSelectRegion *region;
/* 协议勾选 */
@property(nonatomic,weak) UIButton *agreeBtn;
/* 弹框 */
@property (nonatomic, strong) zhPopupController *alertPopVC;
@end

@implementation GXRegisterAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"注册验证"];
    self.mainStore = [[GXRegisterStore alloc] init];
    [self setUpTableView];
    self.region = [[GXSelectRegion alloc] init];
    [self getRegionRequest];
    [self getCatalogItemRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 480);
    self.footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 110);
}
#pragma mark -- 视图相关
-(NSMutableArray *)stores
{
    if (_stores == nil) {
        _stores = [NSMutableArray array];
    }
    return _stores;
}
-(GXRegisterAuthHeader *)header
{
    if (_header == nil) {
        _header = [GXRegisterAuthHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 480);
        _header.target = self;
        _header.mainStore = self.mainStore;
        hx_weakify(self);
        _header.storeTypeCall = ^{
            hx_strongify(weakSelf);
            [strongSelf.tableView reloadData];
        };
    }
    return _header;
}
-(GXRegisterAuthFooter *)footer
{
    if (_footer == nil) {
        _footer = [GXRegisterAuthFooter loadXibView];
        _footer.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 110);
        self.agreeBtn = _footer.agreeBtn;
        hx_weakify(self);
        _footer.agreementCall = ^{
            hx_strongify(weakSelf);
            GXWebContentVC *wvc = [GXWebContentVC new];
            wvc.navTitle = @"母婴店注册协议";
            wvc.isNeedRequest = YES;
            wvc.requestType = 1;
            [strongSelf.navigationController pushViewController:wvc animated:YES];
        };
        _footer.submitStoreCall = ^(UIButton * _Nonnull btn) {
            hx_strongify(weakSelf);
            [strongSelf checkDataValidity];
        };
    }
    return _footer;
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXRegisterAuthCell class]) bundle:nil] forCellReuseIdentifier:RegisterAuthCell];
    
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
}
#pragma mark -- 业务接口
-(void)getCatalogItemRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getCatalogItem" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.catalogItem = [NSArray yy_modelArrayWithClass:[GXCatalogItem class] json:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.header.catalogItem = strongSelf.catalogItem;
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getRegionRequest
{
//    hx_weakify(self);
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        hx_strongify(weakSelf);
//
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"areaData" ofType:@"txt"];
//        NSString *districtStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
//
//        if (districtStr == nil) {
//            return;
//        }
//        NSData *jsonData = [districtStr dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//        strongSelf.region = [[GXSelectRegion alloc] init];
//        strongSelf.region.regions = [NSArray yy_modelArrayWithClass:[GXRegion class] json:responseObject[@"data"]];
//    });
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getAllProvince" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.region.regions = [NSArray yy_modelArrayWithClass:[GXRegion class] json:responseObject[@"data"]];
            strongSelf.mainStore.region = strongSelf.region;
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)checkDataValidity
{
    if (!self.mainStore.shop_type.length) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择门店类型"];
        return;
    }
    if (!self.mainStore.shop_name.length) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写门店名称"];
        return;
    }
    if (!self.mainStore.town_id.length) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择门店地址"];
        return;
    }
    if (!self.mainStore.shop_address.length) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写门店详细地址"];
        return;
    }
    if (!self.mainStore.catalogs.length) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择经营类目"];
        return;
    }
    if (!self.mainStore.month_turnover.length) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写月营业额"];
        return;
    }
    if (!self.mainStore.business_license_img.length) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传营业执照"];
        return;
    }
    if (!self.mainStore.shop_front_img.length) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传门店正面照"];
        return;
    }
    if (!self.mainStore.shop_inside_img.length) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传门店内部照"];
        return;
    }
    if (!self.mainStore.card_front_img.length) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传身份证正面照"];
        return;
    }
    if (!self.mainStore.card_back_img.length) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传身份证反面照"];
        return;
    }
    
    // 门店类型：1单门店；2连锁
    if ([self.mainStore.shop_type isEqualToString:@"2"]) {
        BOOL isPrefect = YES;
        for (GXRegisterStore *store in self.stores) {
            if (!store.shop_name.length || !store.town_id.length || !store.shop_address.length || !store.business_license_img.length) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"连锁门店信息不全"];
                isPrefect = NO;
                break;
            }
        }
        if (!isPrefect) {
            return;
        }
        if (self.stores.count < 2) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"连锁门店至少2个"];
            return;
        }
    }
    
    if (!self.footer.agreeBtn.isSelected) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请阅读勾选注册协议"];
        return;
    }
    [self submitStoreRequest];
}
-(void)submitStoreRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"username"] = self.username;//姓名
    parameters[@"phone"] = self.phone;//手机号
    parameters[@"pwd"] = self.pwd;//密码
    parameters[@"share_code"] = self.inviteCode;//邀请码
    parameters[@"shop_type"] = self.mainStore.shop_type;//门店类型：1单门店；2连锁。供应商默认为1
    parameters[@"shop_name"] = self.mainStore.shop_name;//主门店名称
    parameters[@"shop_address"] = [NSString stringWithFormat:@"%@%@",self.mainStore.shop_area,self.mainStore.shop_address];//店铺详细地址
    parameters[@"month_turnover"] = self.mainStore.month_turnover;//月度营业额
    parameters[@"business_license_img"] = self.mainStore.business_license_img;//营业执照图片
    parameters[@"shop_front_img"] = self.mainStore.shop_front_img;//门店正面照
    parameters[@"shop_inside_img"] = self.mainStore.shop_inside_img;//门店内部照
    parameters[@"card_front_img"] = self.mainStore.card_front_img;//身份证正面照
    parameters[@"card_back_img"] = self.mainStore.card_back_img;//身份证背面照
    parameters[@"food_license_img"] = (self.mainStore.food_license_img && self.mainStore.food_license_img.length)?self.mainStore.food_license_img:@"";//食品经营许可证
    parameters[@"town_id"] = self.mainStore.town_id;//店铺所属镇
    parameters[@"catalogs"] = self.mainStore.catalogs;//经营类目 多个catalog_id间用逗号隔开
    if ([self.mainStore.shop_type isEqualToString:@"2"]) {
        NSMutableArray *userShops = [NSMutableArray array];
        for (GXRegisterStore *store in self.stores) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"shop_name"] = store.shop_name;
            dict[@"town_id"] = store.town_id;
            dict[@"shop_address"] = store.shop_address;
            dict[@"business_license_img"] = store.business_license_img;
            [userShops addObject:dict];
        }
        parameters[@"userShops"] = [userShops yy_modelToJSONString];//多门店店铺 参数为二维数组
    }else{
        parameters[@"userShops"] = @"";//多门店店铺 参数为二维数组
    }

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/register" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf showNoticeAlert:[responseObject objectForKey:@"message"]];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)showNoticeAlert:(NSString *)msg
{
    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:msg constantWidth:HX_SCREEN_WIDTH - 50*2];
    hx_weakify(self);
    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"我知道了" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.alertPopVC dismiss];
        [strongSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
    okButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [okButton setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    [alert addAction:okButton];
    self.alertPopVC = [[zhPopupController alloc] initWithView:alert size:alert.bounds.size];
    self.alertPopVC.dismissOnMaskTouched = NO;
    [self.alertPopVC show];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 门店类型：1单门店；2连锁。供应商默认为1
    if ([self.mainStore.shop_type isEqualToString:@"2"]) {
        return self.stores.count;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXRegisterAuthCell *cell = [tableView dequeueReusableCellWithIdentifier:RegisterAuthCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.target = self;
    GXRegisterStore *store = self.stores[indexPath.row];
    cell.store = store;
    hx_weakify(self);
    cell.cancelStoreCall = ^{
        hx_strongify(weakSelf);
        [strongSelf.stores removeObject:store];
        [tableView reloadData];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 300.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // 门店类型：1单门店；2连锁。供应商默认为1
    if ([self.mainStore.shop_type isEqualToString:@"2"]) {
        return 60.f;
    }else{
        return 0.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    GXRegisterAddStoreFooter *footer = [GXRegisterAddStoreFooter loadXibView];
    if ([self.mainStore.shop_type isEqualToString:@"2"]) {
        footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 60.f);
        hx_weakify(self);
        footer.addStoreCall = ^{
            hx_strongify(weakSelf);
            if (strongSelf.region && strongSelf.region.regions.count) {
                GXRegisterStore *store = [GXRegisterStore new];
                GXSelectRegion *region = [[GXSelectRegion alloc] init];
                region.regions = strongSelf.region.regions;
                store.region = region;
                [strongSelf.stores addObject:store];
                [tableView reloadData];
            }
        };
        return footer;
    }else{
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


@end
