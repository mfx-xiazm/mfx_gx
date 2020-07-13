//
//  GXAuthStep1VC.m
//  GX
//
//  Created by 夏增明 on 2020/2/14.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXAuthStep1VC.h"
#import "GXSelectRegion.h"
#import "GXRegion.h"
#import "GXRegisterData.h"
#import "GXChooseAddressView.h"
#import "GXRunCategoryView.h"
#import <zhPopupController.h>
#import "FSActionSheet.h"
#import "zhAlertView.h"
#import "GXCatalogItem.h"
#import "WSDatePickerView.h"
#import "GXWebContentVC.h"

@interface GXAuthStep1VC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *auth_view;
@property (weak, nonatomic) IBOutlet UILabel *auth_state;
@property (weak, nonatomic) IBOutlet UIScrollView *apply_view;
@property (weak, nonatomic) IBOutlet UIButton *reSubmitBtn;

@property (nonatomic, weak) IBOutlet UITextField *control_type;//供应商的供应商品类型，即控价类型：1 A类；2 B类；3 A类和B类。母婴店为0
@property (weak, nonatomic) IBOutlet UIButton *contectTureBtn;//已对接
@property (weak, nonatomic) IBOutlet UIButton *contectFlaseBtn;//未对接
@property (nonatomic, weak) IBOutlet UIView *cg_view;//对接人
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cg_view_height;//对接人视图高度
@property (nonatomic, weak) IBOutlet UITextField *cg_name;//对接人姓名
@property (nonatomic, weak) IBOutlet UITextField *provider_type;//门店类型：供应商本身的类型
@property (nonatomic, weak) IBOutlet UITextField *catalogs;//经营类目 经营类目 多个catalog_id间用逗号隔开

@property (nonatomic, weak) IBOutlet UITextField *company;//公司名称
@property (weak, nonatomic) IBOutlet UITextField *legal_person;//法人姓名
@property (weak, nonatomic) IBOutlet UITextField *card_id;//身份证号
@property (weak, nonatomic) IBOutlet UITextField *credit_code;//社会信用代码
@property (nonatomic, weak) IBOutlet UITextField *shop_name;//门店名称
@property (nonatomic, weak) IBOutlet UITextField *shop_open_time;//店铺开店时间
@property (nonatomic, weak) IBOutlet UITextField *shop_area;//店铺地址
@property (nonatomic, weak) IBOutlet UITextField *shop_address;//店铺详细地址
@property (nonatomic, weak) IBOutlet UITextField *month_turnover;//年度营业额
@property (nonatomic, weak) IBOutlet UIImageView *business_license_img;//营业执照图片
@property (nonatomic, weak) IBOutlet UIImageView *shop_front_img;//门店正面照
@property (nonatomic, weak) IBOutlet UIImageView *shop_inside_img;//门店内部照
@property (nonatomic, weak) IBOutlet UIImageView *food_license_img;//食品经营许可证

@property (nonatomic, weak) IBOutlet UITextField *postion;//职务
@property (nonatomic, weak) IBOutlet UITextField *wx_code;//微信号
@property (nonatomic, weak) IBOutlet UITextField *memo;//备注

@property (weak, nonatomic) IBOutlet UIButton *agree_btn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
/* 供应商的供应商品类型，即控价类型：1 A类；2 B类；3 A类和B类 */
@property(nonatomic,copy) NSString *control_type_id;
/* 店铺所属镇 */
@property(nonatomic,copy) NSString *town_id;
/* 经营类目 多个catalog_id间用逗号隔开 */
@property(nonatomic,copy) NSString *catalog_id;
@property (nonatomic, copy) NSString *business_license_url;//营业执照图片
@property (nonatomic, copy) NSString *shop_front_url;//门店正面照
@property (nonatomic, copy) NSString *shop_inside_url;//门店内部照
@property (nonatomic, copy) NSString *food_license_url;//食品经营许可证

/* 经营类目 */
@property(nonatomic,strong) GXRegisterData *registerData;
/* 所有地区 */
@property(nonatomic,strong) GXSelectRegion *region;
/* 选择当前操作的图片按钮 */
@property(nonatomic,strong) UIButton *selectBtn;
/* 地址 */
@property(nonatomic,strong) GXChooseAddressView *addressView;
/* 类目view */
@property(nonatomic,strong) GXRunCategoryView *cateItemView;
/* 选中的供应商类型 */
@property(nonatomic,strong) GXProviderType *selectProviderType;

@end

@implementation GXAuthStep1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"申请入驻"];
    if (self.approve_status && self.approve_status.length) {
        self.auth_view.hidden = NO;
        self.apply_view.hidden = YES;
        if ([self.approve_status isEqualToString:@"1"]) {
            self.auth_state.text = @"提交成功，请耐心等待审核";
        }else{
            self.reSubmitBtn.hidden = NO;
            self.auth_state.text = [NSString stringWithFormat:@"被拒原因：%@",self.reject_reason];
        }
    }else{
        self.auth_view.hidden = YES;
        self.apply_view.hidden = NO;
        [self getCatalogItemRequest];
        [self getAllAreaRequest];
    }
    
    hx_weakify(self);
    [self.sureBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.control_type hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择供货类型"];
            return NO;
        }
//        if (strongSelf.contectTureBtn.isSelected) {
//            if (![strongSelf.cg_name hasText]) {
//                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入对接人姓名"];
//                return NO;
//            }
//        }
        if (![strongSelf.provider_type hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择供应商类型"];
            return NO;
        }
        if (![strongSelf.catalogs hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择经营类目"];
            return NO;
        }
        if (![strongSelf.company hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写公司名称"];
            return NO;
        }
        if (![strongSelf.legal_person hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写法人姓名"];
            return NO;
        }
        if (![strongSelf.card_id hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写身份证号"];
            return NO;
        }
        if (![strongSelf.card_id.text judgeIdentityStringValid]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"身份证号有误"];
            return NO;
        }
        if (![strongSelf.credit_code hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写统一社会信用代码"];
            return NO;
        }
        if (![strongSelf.shop_name hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写店铺名称"];
            return NO;
        }
//        if (![strongSelf.shop_open_time hasText]) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择开店时间"];
//            return NO;
//        }
        if (![strongSelf.shop_area hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择所在地区"];
            return NO;
        }
        if (![strongSelf.shop_address hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写详细地址"];
            return NO;
        }
        if (![strongSelf.month_turnover hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写年营业额"];
            return NO;
        }
        if (!strongSelf.business_license_url.length) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传营业执照"];
            return NO;
        }
//        if (!strongSelf.shop_front_url.length) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传门店正面照"];
//            return NO;
//        }
//        if (!strongSelf.shop_inside_url.length) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传门店内部照"];
//            return NO;
//        }
//        if (![strongSelf.postion hasText]) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写职务"];
//            return NO;
//        }
//        if (![strongSelf.wx_code hasText]) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写微信号"];
//            return NO;
//        }
        if (!strongSelf.agree_btn.isSelected) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请阅读勾选注册协议"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {        hx_strongify(weakSelf);

        [strongSelf submitRegisterRequest:button];
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
            [weakSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
            if (type) {
                weakSelf.shop_area.text = [NSString stringWithFormat:@"%@%@%@%@",region.selectRegion.area_alias,region.selectCity.area_alias,region.selectArea.area_alias,region.selectTown.area_alias];
                weakSelf.town_id = region.selectTown.area_id;
            }
        };
    }
    return _addressView;
}
-(GXRunCategoryView *)cateItemView
{
    if (_cateItemView == nil) {
        _cateItemView = [GXRunCategoryView loadXibView];
        _cateItemView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-30*2, 260);
    }
    return _cateItemView;
}
#pragma mark -- 业务接口
-(void)submitRegisterRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = self.uid;//用户id
    parameters[@"token"] = self.token;//用户验证
    parameters[@"control_type"] = self.control_type_id;//应商的供应商品类型
    parameters[@"provider_type_id"] = self.selectProviderType.provider_type_id;//供应商本身的类型
    parameters[@"cg_name"] = [self.cg_name hasText]?self.cg_name.text:@"";//对接采购者姓名
    parameters[@"catalogs"] = self.catalog_id;//经营类目 多个catalog_id间用逗号隔开
    
    parameters[@"company"] = self.company.text;//公司名称
    parameters[@"shop_name"] = [self.shop_name hasText]?self.shop_name.text:@"";//门店名称
    parameters[@"shop_address"] = [self.shop_address hasText]?self.shop_address.text:@"";//店铺详细地址
    parameters[@"town_id"] = [self.shop_area hasText]?self.town_id:@"";//店铺所属镇
    parameters[@"shop_open_time"] = @"";//店铺开店时间
    parameters[@"legal_person"] = self.legal_person.text;//法人代表
    parameters[@"card_id"] = self.card_id.text;//身份证号码
    parameters[@"credit_code"] = self.credit_code.text;//统一社会信用代码
    parameters[@"month_turnover"] = self.month_turnover.text;//年度营业额
    parameters[@"business_license_img"] = self.business_license_url;//营业执照图片
    parameters[@"shop_front_img"] = (self.shop_front_url && self.shop_front_url.length)?self.shop_front_url:@"";//门店正面照
    parameters[@"shop_inside_img"] = (self.shop_inside_url && self.shop_inside_url.length)?self.shop_inside_url:@"";//门店内部照
    parameters[@"food_license_img"] = (self.food_license_url && self.food_license_url.length)?self.food_license_url:@"";//食品经营许可证
    
    parameters[@"postion"] = [self.postion hasText]?self.postion.text:@"";//职务
    parameters[@"wx_code"] = [self.wx_code hasText]?self.wx_code.text:@"";//微信号
    parameters[@"memo"] = [self.memo hasText]?self.memo.text:@"";//备注

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"index/supplierSettledIn" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.auth_view.hidden = NO;
                strongSelf.auth_state.text = @"提交成功，请耐心等待审核";
                strongSelf.reSubmitBtn.hidden = YES;
                strongSelf.apply_view.hidden = YES;
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getCatalogItemRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"index/registerData" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.registerData = [GXRegisterData yy_modelWithDictionary:responseObject[@"data"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getAllAreaRequest
{
    hx_weakify(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        hx_strongify(weakSelf);
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"areaData" ofType:@"txt"];
        NSString *districtStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
        
        if (districtStr == nil) {
            return ;
        }
        NSData *jsonData = [districtStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        strongSelf.region = [[GXSelectRegion alloc] init];
        strongSelf.region.regions = [NSArray yy_modelArrayWithClass:[GXRegion class] json:responseObject[@"data"]];
    });
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"index/getAreaData" parameters:@{} success:^(id responseObject) {
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
#pragma mark -- 点击事件
- (IBAction)signNoticeClicked:(UIButton *)sender {
    GXWebContentVC *wvc = [GXWebContentVC new];
    wvc.navTitle = @"银联签约资质说明";
    wvc.isNeedRequest = NO;
    wvc.url = [NSString stringWithFormat:@"%@unionDesc.jpg",HXRC_URL_HEADER];
    [self.navigationController pushViewController:wvc animated:YES];
}
- (IBAction)resubmitClicked:(UIButton *)sender {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = self.uid;//用户id
    parameters[@"token"] = self.token;//用户验证

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"index/supplierResetRegister" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.auth_view.hidden = YES;
                strongSelf.reSubmitBtn.hidden = YES;
                strongSelf.apply_view.hidden = NO;
                [strongSelf getCatalogItemRequest];
                [strongSelf getAllAreaRequest];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
- (IBAction)contectClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        self.contectTureBtn.selected = YES;
        self.contectFlaseBtn.selected = NO;
        self.cg_view.hidden = NO;
        self.cg_view_height.constant = 50.f;
    }else{
        self.contectTureBtn.selected = NO;
        self.contectFlaseBtn.selected = YES;
        self.cg_view.hidden = YES;
        self.cg_view_height.constant = 0.f;
    }
}
- (IBAction)yewuClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        NSArray *titles = @[@"A类",@"B类",@"A类/B类"];
        NSArray *values = @[@"1",@"2",@"3"];

        FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:@"供应类别" delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:titles];
        hx_weakify(self);
        [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
            hx_strongify(weakSelf);
            strongSelf.control_type.text = titles[selectedIndex];
            strongSelf.control_type_id = values[selectedIndex];
        }];
    }else if (sender.tag == 2) {
        NSMutableArray *titles = [NSMutableArray array];
        for (GXProviderType *type in self.registerData.provider_type) {
            [titles addObject:type.provider_type_name];
        }
        FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:@"供应商类型" delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:titles];
        hx_weakify(self);
        [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
            hx_strongify(weakSelf);
            strongSelf.selectProviderType = strongSelf.registerData.provider_type[selectedIndex];
            strongSelf.provider_type.text = strongSelf.selectProviderType.provider_type_name;
        }];
    }else if (sender.tag == 3) {
        self.cateItemView.catalogItem = self.registerData.catalog;
        hx_weakify(self);
        self.cateItemView.runCateCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
            if (index == 1) {
                NSMutableString *itemStr = [NSMutableString string];
                NSMutableString *itemids = [NSMutableString string];
                for (GXCatalogItem *item in strongSelf.registerData.catalog) {
                    if (item.isSelected) {
                        if (itemStr.length) {
                            [itemStr appendFormat:@",%@",item.catalog_name];
                            [itemids appendFormat:@",%@",item.catalog_id];
                        }else{
                            [itemStr appendFormat:@"%@",item.catalog_name];
                            [itemids appendFormat:@"%@",item.catalog_id];
                        }
                    }
                }
                strongSelf.catalogs.text = itemStr;
                strongSelf.catalog_id = itemids;
            }
        };
        self.zh_popupController = [[zhPopupController alloc] init];
        self.zh_popupController.layoutType = zhPopupLayoutTypeCenter;
        [self.zh_popupController presentContentView:self.cateItemView duration:0.25 springAnimated:NO];
    }else if (sender.tag == 4) {
        //年-月-日
        hx_weakify(self);
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
            hx_strongify(weakSelf);
            NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            strongSelf.shop_open_time.text = dateString;
        }];
        datepicker.maxLimitDate = [NSDate date];
        datepicker.dateLabelColor = HXControlBg;//年-月-日 颜色
        datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
        datepicker.doneButtonColor = HXControlBg;//确定按钮的颜色
        [datepicker show];
    }else{
        if (!self.region || !self.region.regions.count) {
            return;
        }
        self.addressView.region = self.region;
        self.zh_popupController = [[zhPopupController alloc] init];
        self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
        [self.zh_popupController presentContentView:self.addressView duration:0.25 springAnimated:NO];
    }
}
- (IBAction)chooseImgClicked:(UIButton *)sender {
    
    self.selectBtn = sender;
    
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"]];
    hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        hx_strongify(weakSelf);
        if (selectedIndex == 0) {
            [strongSelf awakeImagePickerController:@"1"];
        }else{
            [strongSelf awakeImagePickerController:@"2"];
        }
    }];
}
- (IBAction)seletAgreeClicked:(UIButton *)sender {
    self.agree_btn.selected = !self.agree_btn.selected;
}
- (IBAction)agreeMentClicked:(UIButton *)sender {
    GXWebContentVC *wvc = [GXWebContentVC new];
    wvc.navTitle = @"供应商注册协议";
    wvc.isNeedRequest = YES;
    wvc.requestType = 8;
    [self.navigationController pushViewController:wvc animated:YES];
}
#pragma mark -- 唤起相机
- (void)awakeImagePickerController:(NSString *)pickerType {
    if ([pickerType isEqualToString:@"1"]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            if ([self isCanUseCamera]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                //前后摄像头是否可用
                [UIImagePickerController isCameraDeviceAvailable:YES];
                //相机闪光灯是否OK
                [UIImagePickerController isFlashAvailableForCameraDevice:YES];
                if (@available(iOS 13.0, *)) {
                    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
                    /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
                    imagePickerController.modalInPresentation = YES;
                }
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else{
                hx_weakify(self);
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.zh_popupController dismiss];
                }];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert addAction:okButton];
                self.zh_popupController = [[zhPopupController alloc] init];
                [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"相机不可用"];
            return;
        }
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            if ([self isCanUsePhotos]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //前后摄像头是否可用
                [UIImagePickerController isCameraDeviceAvailable:YES];
                //相机闪光灯是否OK
                [UIImagePickerController isFlashAvailableForCameraDevice:YES];
                if (@available(iOS 13.0, *)) {
                    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
                    /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
                    imagePickerController.modalInPresentation = YES;
                }
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else{
                hx_weakify(self);
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相册权限" message:@"设置-隐私-相册" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.zh_popupController dismiss];
                }];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert addAction:okButton];
                self.zh_popupController = [[zhPopupController alloc] init];
                [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"相册不可用"];
            return;
        }
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    hx_weakify(self);
    [picker dismissViewControllerAnimated:YES completion:^{
        hx_strongify(weakSelf);
        // 显示保存图片
        [strongSelf upImageRequestWithImage:info[UIImagePickerControllerEditedImage] completedCall:^(NSString *imageUrl,NSString * imagePath) {
            if (strongSelf.selectBtn.tag == 1) {
                [strongSelf.business_license_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                strongSelf.business_license_url = imageUrl;
            }else if (strongSelf.selectBtn.tag == 2) {
                [strongSelf.shop_front_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                strongSelf.shop_front_url = imageUrl;
            }else if (strongSelf.selectBtn.tag == 3) {
                [strongSelf.shop_inside_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                strongSelf.shop_inside_url = imageUrl;
            }else {
                [strongSelf.food_license_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                strongSelf.food_license_url = imageUrl;
            }
        }];
    }];
}
-(void)upImageRequestWithImage:(UIImage *)image completedCall:(void(^)(NSString * imageUrl,NSString * imagePath))completedCall
{
    [HXNetworkTool uploadImagesWithURL:HXRC_M_URL action:@"index/uploadFile" parameters:@{} name:@"file" images:@[image] fileNames:nil imageScale:0.8 imageType:@"png" progress:nil success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            completedCall(responseObject[@"data"][@"path"],responseObject[@"data"][@"imgPath"]);
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}

@end
