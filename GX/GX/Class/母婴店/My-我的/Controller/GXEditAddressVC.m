//
//  GXEditAddressVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXEditAddressVC.h"
#import "GXChooseAddressView.h"
#import <zhPopupController.h>
#import "HXPlaceholderTextView.h"
#import "GXSelectRegion.h"
#import "GXMyAddress.h"
#import "UITextField+GYExpand.h"

@interface GXEditAddressVC ()
@property (weak, nonatomic) IBOutlet UITextField *receiver;
@property (weak, nonatomic) IBOutlet UITextField *receiver_phone;
@property (weak, nonatomic) IBOutlet UITextField *area_name;
@property (weak, nonatomic) IBOutlet UIButton *is_defalt;
@property (weak, nonatomic) IBOutlet UIView *address_detail_view;
@property (strong, nonatomic) HXPlaceholderTextView *addressDetial;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

/* 地址 */
@property(nonatomic,strong) GXChooseAddressView *addressView;
/* 所有地区 */
@property(nonatomic,strong) GXSelectRegion *region;
/* 省id */
@property(nonatomic,copy) NSString *province_id;
/* 市id */
@property(nonatomic,copy) NSString *city_id;
/* 行政区id */
@property(nonatomic,copy) NSString *district_id;
/* 镇id*/
@property(nonatomic,copy) NSString *town_id;
/* 地址选择框 */
@property (nonatomic, strong) zhPopupController *addressPopVC;
@end

@implementation GXEditAddressVC

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.addressDetial.frame = self.address_detail_view.bounds;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:self.address?@"编辑地址":@"新增地址"];

    self.addressDetial = [[HXPlaceholderTextView alloc] initWithFrame:self.address_detail_view.bounds];
    self.addressDetial.placeholder = @"请输入详细的收货地址";
    [self.address_detail_view addSubview:self.addressDetial];
    
    hx_weakify(self);
    [self.receiver_phone lengthLimit:^{
        hx_strongify(weakSelf);
        if (strongSelf.receiver_phone.text.length > 11) {
            strongSelf.receiver_phone.text = [strongSelf.receiver_phone.text substringToIndex:11];
        }
    }];
    
    if (self.address) {
        self.receiver.text = _address.receiver;
        self.receiver_phone.text = _address.receiver_phone;
        self.area_name.text = _address.area_name;
        self.addressDetial.text = _address.address_detail;
        self.is_defalt.selected = _address.is_default;
        self.province_id = _address.province_id;
        self.city_id = _address.city_id;
        self.district_id = _address.district_id;
        self.town_id = _address.town_id;
    }
    [self getAllAreaRequest];
    
    [self.sureBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.receiver_phone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写收货人手机号"];
            return NO;
        }
        if (strongSelf.receiver_phone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机号格式有误"];
            return NO;
        }
        if (![strongSelf.receiver hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写收货人"];
            return NO;
        }
        if (![strongSelf.area_name hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择地区"];
            return NO;
        }
        if (![strongSelf.addressDetial hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写详细地址"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf saveAddressRequest:button];
    }];
}
-(GXChooseAddressView *)addressView
{
    if (_addressView == nil) {
        _addressView = [GXChooseAddressView loadXibView];
        _addressView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 360);
        _addressView.componentsNum = 4;
        __weak __typeof(self) weakSelf = self;
        // 最后一列的行被点击的回调
        _addressView.lastComponentClickedBlock = ^(NSInteger type, GXSelectRegion * _Nullable region) {
            [weakSelf.addressPopVC dismissWithDuration:0.25 completion:nil];
            if (type) {
                weakSelf.area_name.text = [NSString stringWithFormat:@"%@%@%@%@",region.selectRegion.area_alias,region.selectCity.area_alias,region.selectArea.area_alias,region.selectTown.area_alias];
                weakSelf.province_id = region.selectRegion.area_id;
                weakSelf.city_id = region.selectCity.area_id;
                weakSelf.district_id = region.selectArea.area_id;
                weakSelf.town_id = region.selectTown.area_id;
            }
        };
    }
    return _addressView;
}
-(zhPopupController *)addressPopVC
{
    if (!_addressPopVC) {
        _addressPopVC = [[zhPopupController alloc] initWithView:self.addressView size:self.addressView.bounds.size];
        _addressPopVC.layoutType = zhPopupLayoutTypeBottom;
    }
    return _addressPopVC;
}
- (IBAction)defaultClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)regionClicked:(UIButton *)sender {
    if (!self.region || !self.region.regions.count) {
        return;
    }
    [self.view endEditing:YES];

    self.addressView.region = self.region;
    [self.addressPopVC show];
}

-(void)getAllAreaRequest
{
    hx_weakify(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        hx_strongify(weakSelf);
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"areaData" ofType:@"txt"];
        NSString *districtStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
        
        if (districtStr == nil) {
            return;
        }
        NSData *jsonData = [districtStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        strongSelf.region = [[GXSelectRegion alloc] init];
        strongSelf.region.regions = [NSArray yy_modelArrayWithClass:[GXRegion class] json:responseObject[@"data"]];
    });
//    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getAreaData" parameters:@{} success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            strongSelf.region = [[GXSelectRegion alloc] init];
//            strongSelf.region.regions = [NSArray yy_modelArrayWithClass:[GXRegion class] json:responseObject[@"data"]];
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
}
-(void)saveAddressRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"receiver"] = self.receiver.text;
    parameters[@"receiver_phone"] = self.receiver_phone.text;
    parameters[@"area_name"] = self.area_name.text;
    parameters[@"province_id"] = self.province_id;
    parameters[@"city_id"] = self.city_id;
    parameters[@"district_id"] = self.district_id;
    parameters[@"town_id"] = self.town_id;

    parameters[@"address_detail"] = self.addressDetial.text;
    parameters[@"is_default"] = @(self.is_defalt.isSelected);
    if (self.address) {
        parameters[@"address_id"] = self.address.address_id;
    }
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:self.address?@"admin/editAddress":@"admin/addAddress" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (strongSelf.editSuccessCall) {
                strongSelf.editSuccessCall();
            }
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
