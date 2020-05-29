//
//  GXRegisterAuthHeader.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXRegisterAuthHeader.h"
#import "GXRunCategoryView.h"
#import <zhPopupController.h>
#import "GXChooseAddressView.h"
#import "GXRegisterStore.h"
#import "FSActionSheet.h"
#import "GXCatalogItem.h"
#import "GXRegion.h"
#import "GXSelectRegion.h"
#import "zhAlertView.h"
#import "HXBaseViewController.h"

@interface GXRegisterAuthHeader ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, weak) IBOutlet UITextField *shop_type;//门店类型：1单门店；2连锁。供应商默认为1
@property (nonatomic, weak) IBOutlet UITextField *shop_name;//主门店名称
@property (nonatomic, weak) IBOutlet UITextField *shop_area;//店铺地址
@property (nonatomic, weak) IBOutlet UITextField *shop_address;//店铺详细地址
@property (nonatomic, weak) IBOutlet UITextField *month_turnover;//月度营业额
@property (nonatomic, weak) IBOutlet UIImageView *business_license_img;//营业执照图片
@property (nonatomic, weak) IBOutlet UIImageView *shop_front_img;//门店正面照
@property (nonatomic, weak) IBOutlet UIImageView *shop_inside_img;//门店内部照
@property (nonatomic, weak) IBOutlet UIImageView *card_front_img;//身份证正面照
@property (nonatomic, weak) IBOutlet UIImageView *card_back_img;//身份证背面照
@property (nonatomic, weak) IBOutlet UIImageView *food_license_img;//食品经营许可证
@property (nonatomic, weak) IBOutlet UITextField *catalogs;//经营类目 经营类目 多个catalog_id间用逗号隔开
/* 选择当前操作的图片按钮 */
@property(nonatomic,strong) UIButton *selectBtn;
/* 地址 */
@property(nonatomic,strong) GXChooseAddressView *addressView;
/* 类目view */
@property(nonatomic,strong) GXRunCategoryView *cateItemView;
@end
@implementation GXRegisterAuthHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.shop_name.delegate = self;
    self.shop_address.delegate = self;
    self.month_turnover.delegate = self;
}
#pragma mark -- 懒加载
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.shop_name) {
        self.mainStore.shop_name = [textField hasText]?textField.text:@"";
    }else if (textField == self.shop_address) {
        self.mainStore.shop_address = [textField hasText]?textField.text:@"";
    }else{
        self.mainStore.month_turnover = [textField hasText]?textField.text:@"";
    }
}
#pragma mark -- 懒加载
-(GXChooseAddressView *)addressView
{
    if (_addressView == nil) {
        _addressView = [GXChooseAddressView loadXibView];
        _addressView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 360);
        _addressView.componentsNum = 4;
        __weak __typeof(self) weakSelf = self;
        // 最后一列的行被点击的回调
        _addressView.lastComponentClickedBlock = ^(NSInteger type, GXSelectRegion * _Nullable region) {
            [weakSelf.target.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
            if (type) {
                weakSelf.shop_area.text = [NSString stringWithFormat:@"%@%@%@%@",region.selectRegion.area_alias,region.selectCity.area_alias,region.selectArea.area_alias,region.selectTown.area_alias];
                weakSelf.mainStore.shop_area = weakSelf.shop_area.text;
                weakSelf.mainStore.town_id = region.selectTown.area_id;
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
#pragma mark -- 点击事件
- (IBAction)chooseStoreTypeClicked:(UIButton *)sender {
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:@"门店类型" delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"单门店",@"连锁店"]];
    hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        hx_strongify(weakSelf);
        if (selectedIndex == 0) {
            strongSelf.shop_type.text = @"单门店";
            strongSelf.mainStore.shop_type = @"1";
        }else {
            strongSelf.shop_type.text = @"连锁店";
            strongSelf.mainStore.shop_type = @"2";
        }
        if (strongSelf.storeTypeCall) {
            strongSelf.storeTypeCall();
        }
    }];
}

- (IBAction)chooseAdressClicked:(UIButton *)sender {
    if (!self.region || !self.region.regions.count) {
        return;
    }
    self.addressView.region = self.region;
    self.target.zh_popupController = [[zhPopupController alloc] init];
    self.target.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.target.zh_popupController presentContentView:self.addressView duration:0.25 springAnimated:NO];
}

- (IBAction)chooseCateClicked:(UIButton *)sender {
    
    self.cateItemView.catalogItem = self.catalogItem;
    hx_weakify(self);
    self.cateItemView.runCateCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        [strongSelf.target.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        if (index == 1) {
            NSMutableString *itemStr = [NSMutableString string];
            NSMutableString *itemids = [NSMutableString string];
            for (GXCatalogItem *item in strongSelf.catalogItem) {
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
            strongSelf.mainStore.catalogs = itemids;
        }
    };
    self.target.zh_popupController = [[zhPopupController alloc] init];
    self.target.zh_popupController.layoutType = zhPopupLayoutTypeCenter;
    [self.target.zh_popupController presentContentView:self.cateItemView duration:0.25 springAnimated:NO];
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
#pragma mark -- 唤起相机
- (void)awakeImagePickerController:(NSString *)pickerType {
    if ([pickerType isEqualToString:@"1"]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            if ([self.target isCanUseCamera]) {
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
                [self.target presentViewController:imagePickerController animated:YES completion:nil];
            }else{
                hx_weakify(self);
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.target.zh_popupController dismiss];
                }];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert addAction:okButton];
                self.target.zh_popupController = [[zhPopupController alloc] init];
                [self.target.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"相机不可用"];
            return;
        }
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            if ([self.target isCanUsePhotos]) {
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
                [self.target presentViewController:imagePickerController animated:YES completion:nil];
            }else{
                hx_weakify(self);
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相册权限" message:@"设置-隐私-相册" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.target.zh_popupController dismiss];
                }];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert addAction:okButton];
                self.target.zh_popupController = [[zhPopupController alloc] init];
                [self.target.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
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
                strongSelf.mainStore.business_license_img = imageUrl;
            }else if (strongSelf.selectBtn.tag == 2) {
                [strongSelf.shop_front_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                strongSelf.mainStore.shop_front_img = imageUrl;
            }else if (strongSelf.selectBtn.tag == 3) {
                [strongSelf.shop_inside_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                strongSelf.mainStore.shop_inside_img = imageUrl;
            }else if (strongSelf.selectBtn.tag == 4) {
                [strongSelf.card_front_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                strongSelf.mainStore.card_front_img = imageUrl;
            }else if (strongSelf.selectBtn.tag == 5) {
                [strongSelf.card_back_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                strongSelf.mainStore.card_back_img = imageUrl;
            }else{
                [strongSelf.food_license_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                strongSelf.mainStore.food_license_img = imageUrl;
            }
        }];
    }];
}
-(void)upImageRequestWithImage:(UIImage *)image completedCall:(void(^)(NSString * imageUrl,NSString * imagePath))completedCall
{
    [HXNetworkTool uploadImagesWithURL:HXRC_M_URL action:@"admin/uploadFile" parameters:@{} name:@"file" images:@[image] fileNames:nil imageScale:0.8 imageType:@"png" progress:nil success:^(id responseObject) {
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
