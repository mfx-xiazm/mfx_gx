//
//  GXMyLicenceVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMyLicenceVC.h"
#import <ZLPhotoActionSheet.h>
#import <zhPopupController.h>
#import "FSActionSheet.h"
#import "zhAlertView.h"

@interface GXMyLicenceVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *food_lince_view;
@property (weak, nonatomic) IBOutlet UIView *shop_lince_view;

@property (weak, nonatomic) IBOutlet UIImageView *business_license_img;
@property (weak, nonatomic) IBOutlet UIImageView *shop_front_img;
@property (weak, nonatomic) IBOutlet UIImageView *shop_inside_img;
@property (weak, nonatomic) IBOutlet UIImageView *card_front_img;
@property (weak, nonatomic) IBOutlet UIImageView *card_back_img;
@property (weak, nonatomic) IBOutlet UIImageView *food_license_img;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

/* 信息 */
@property(nonatomic,strong) NSMutableDictionary *result;
@end

@implementation GXMyLicenceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:[self.seaType isEqualToString:@"1"]?@"资质信息":@"食品经营许可证"];
    self.food_lince_view.hidden = [self.seaType isEqualToString:@"1"]?YES:NO;
    self.shop_lince_view.hidden = [self.seaType isEqualToString:@"1"]?NO:YES;
    self.changeBtn.hidden = [self.seaType isEqualToString:@"1"]?YES:NO;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClicked:)];
    [self.business_license_img addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClicked:)];
    [self.shop_front_img addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClicked:)];
    [self.shop_inside_img addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClicked:)];
    [self.card_front_img addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClicked:)];
    [self.card_back_img addGestureRecognizer:tap4];
    
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClicked:)];
    [self.food_license_img addGestureRecognizer:tap5];
    
    [self getNaturalDataRequest];
}
-(void)imgTapClicked:(UITapGestureRecognizer *)tap
{
    if ([self.seaType isEqualToString:@"1"]) {
        NSMutableArray * items = [NSMutableArray array];
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        
        temp[@"ZLPreviewPhotoObj"] = [NSURL URLWithString:self.result[@"business_license_img"]];
        temp[@"ZLPreviewPhotoTyp"] = @(ZLPreviewPhotoTypeURLImage);
        [items addObject:temp];
        
        NSMutableDictionary *temp1 = [NSMutableDictionary dictionary];
        temp1[@"ZLPreviewPhotoObj"] = [NSURL URLWithString:self.result[@"shop_front_img"]];
        temp1[@"ZLPreviewPhotoTyp"] = @(ZLPreviewPhotoTypeURLImage);
        [items addObject:temp1];
        
        NSMutableDictionary *temp2 = [NSMutableDictionary dictionary];
        temp2[@"ZLPreviewPhotoObj"] = [NSURL URLWithString:self.result[@"shop_inside_img"]];
        temp2[@"ZLPreviewPhotoTyp"] = @(ZLPreviewPhotoTypeURLImage);
        [items addObject:temp2];
        
        NSMutableDictionary *temp3 = [NSMutableDictionary dictionary];
        temp3[@"ZLPreviewPhotoObj"] = [NSURL URLWithString:self.result[@"card_front_img"]];
        temp3[@"ZLPreviewPhotoTyp"] = @(ZLPreviewPhotoTypeURLImage);
        [items addObject:temp3];
        
        NSMutableDictionary *temp4 = [NSMutableDictionary dictionary];
        temp4[@"ZLPreviewPhotoObj"] = [NSURL URLWithString:self.result[@"card_back_img"]];
        temp4[@"ZLPreviewPhotoTyp"] = @(ZLPreviewPhotoTypeURLImage);
        [items addObject:temp4];
        
        ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
        actionSheet.configuration.navBarColor = HXControlBg;
        actionSheet.configuration.statusBarStyle = UIStatusBarStyleLightContent;
        actionSheet.sender = self;
        [actionSheet previewPhotos:items index:tap.view.tag hideToolBar:YES complete:^(NSArray * _Nonnull photos) {
            
        }];
    }else{
        if (!((NSString *)self.result[@"food_license_img"]).length) {
            return;
        }
        NSMutableArray * items = [NSMutableArray array];
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        temp[@"ZLPreviewPhotoObj"] = [NSURL URLWithString:self.result[@"food_license_img"]];
        temp[@"ZLPreviewPhotoTyp"] = @(ZLPreviewPhotoTypeURLImage);
        [items addObject:temp];
        
        ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
        actionSheet.configuration.navBarColor = HXControlBg;
        actionSheet.configuration.statusBarStyle = UIStatusBarStyleLightContent;
        actionSheet.sender = self;
        [actionSheet previewPhotos:items index:tap.view.tag hideToolBar:YES complete:^(NSArray * _Nonnull photos) {
            
        }];
    }
}
-(void)getNaturalDataRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"seaType"] = self.seaType;//查询类型 1查询资质信息 2查询食品经营许可证

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"index/naturalData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.result = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleNaturalData:responseObject[@"data"]];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)handleNaturalData:(NSDictionary *)result
{
    if ([self.seaType isEqualToString:@"1"]) {
        [self.business_license_img sd_setImageWithURL:[NSURL URLWithString:result[@"business_license_img"]]];
        [self.shop_front_img sd_setImageWithURL:[NSURL URLWithString:result[@"shop_front_img"]]];
        [self.shop_inside_img sd_setImageWithURL:[NSURL URLWithString:result[@"shop_inside_img"]]];
        [self.card_front_img sd_setImageWithURL:[NSURL URLWithString:result[@"card_front_img"]]];
        [self.card_back_img sd_setImageWithURL:[NSURL URLWithString:result[@"card_back_img"]]];
    }else{
        [self.food_license_img sd_setImageWithURL:[NSURL URLWithString:result[@"food_license_img"]]];
    }
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
            [strongSelf.food_license_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
            strongSelf.result[@"food_license_img"] = imagePath;
            [strongSelf updateFoodLicenseImgRequest:imageUrl];
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
-(void)updateFoodLicenseImgRequest:(NSString *)food_license_img
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"food_license_img"] = food_license_img;

    [HXNetworkTool POST:HXRC_M_URL action:@"index/updateFoodLicenseImg" parameters:parameters success:^(id responseObject) {
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
