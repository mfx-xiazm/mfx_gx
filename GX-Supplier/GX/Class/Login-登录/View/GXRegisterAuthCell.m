//
//  GXRegisterAuthCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXRegisterAuthCell.h"
#import "GXRegisterStore.h"
#import "GXSelectRegion.h"
#import "GXChooseAddressView.h"
#import "HXBaseViewController.h"
#import <zhPopupController.h>
#import "FSActionSheet.h"
#import "zhAlertView.h"

@interface GXRegisterAuthCell ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, weak) IBOutlet UITextField *shop_name;//主门店名称
@property (nonatomic, weak) IBOutlet UITextField *shop_area;//店铺地址
@property (nonatomic, weak) IBOutlet UITextField *shop_address;//店铺详细地址
@property (nonatomic, weak) IBOutlet UIImageView *business_license_img;//营业执照图片
/* 地址 */
@property(nonatomic,strong) GXChooseAddressView *addressView;
@end
@implementation GXRegisterAuthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shop_name.delegate = self;
    self.shop_address.delegate = self;
}
- (IBAction)cancelStoreClicked:(UIButton *)sender {
    if (self.cancelStoreCall) {
        self.cancelStoreCall();
    }
}
#pragma mark -- 懒加载
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.shop_name) {
        self.store.shop_name = [textField hasText]?textField.text:@"";
    }else {
        self.store.shop_address = [textField hasText]?textField.text:@"";
    }
}
-(void)setStore:(GXRegisterStore *)store
{
    _store = store;
    
    self.shop_name.text = _store.shop_name;
    self.shop_area.text = _store.shop_area;
    self.shop_address.text = _store.shop_address;
    
    if (_store.business_license_img && _store.business_license_img.length) {
        [self.business_license_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HXRC_URL_HEADER,_store.business_license_img]] placeholderImage:HXGetImage(@"营业执照")];
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
                weakSelf.store.shop_area = weakSelf.shop_area.text;
                weakSelf.store.town_id = region.selectTown.area_id;
            }
        };
    }
    return _addressView;
}
- (IBAction)chooseAdressClicked:(UIButton *)sender {
   
    self.addressView.region = self.store.region;
    self.target.zh_popupController = [[zhPopupController alloc] init];
    self.target.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.target.zh_popupController presentContentView:self.addressView duration:0.25 springAnimated:NO];
}
- (IBAction)chooseImgClicked:(UIButton *)sender {
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
            [strongSelf.business_license_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
            strongSelf.store.business_license_img = imageUrl;
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
