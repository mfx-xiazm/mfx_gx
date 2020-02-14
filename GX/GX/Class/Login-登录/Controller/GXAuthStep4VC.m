//
//  GXAuthStep4VC.m
//  GX
//
//  Created by 夏增明 on 2020/2/14.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXAuthStep4VC.h"
#import "GXAuthStep3VC.h"
#import "FSActionSheet.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "HXTabBarController.h"

@interface GXAuthStep4VC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/** vc控制器 */
@property (nonatomic,strong) NSMutableArray *controllers;
@property (nonatomic, weak) IBOutlet UITextField *company;//公司名称
@property (weak, nonatomic) IBOutlet UITextField *legal_person;//法人姓名
@property (weak, nonatomic) IBOutlet UITextField *card_id;//身份证号
@property (weak, nonatomic) IBOutlet UITextField *credit_code;//社会信用代码
@property (nonatomic, weak) IBOutlet UIImageView *card_front_img;//身份证正面照
@property (nonatomic, weak) IBOutlet UIImageView *card_back_img;//身份证反面照
@property (nonatomic, weak) IBOutlet UIImageView *business_license_img;//营业执照图片
@property (nonatomic, weak) IBOutlet UIButton *sureBtn;//提交

@property (nonatomic, copy) NSString *card_front_url;//身份证正面照
@property (nonatomic, copy) NSString *card_back_url;//身份证反面照
/* 选择当前操作的图片按钮 */
@property(nonatomic,strong) UIButton *selectBtn;
@end

@implementation GXAuthStep4VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"签约"];

    hx_weakify(self);
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[GXAuthStep3VC class]]) {
            hx_strongify(weakSelf);
            [strongSelf.controllers removeObjectAtIndex:idx];
        }
    }];
    [self.navigationController setViewControllers:self.controllers];
    
    [self startShimmer];
    [self getSupplierInfoRequest];
    
    [self.sureBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (!strongSelf.card_front_url.length) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传身份证正面照"];
            return NO;
        }
        if (!strongSelf.card_back_url.length) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传身份证反面照"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf submitSupplierInfoRequest:button];
    }];
}
- (NSMutableArray *)controllers {
    if (!_controllers) {
        _controllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    }
    return _controllers;
}
-(void)getSupplierInfoRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = self.uid;//用户id
    parameters[@"token"] = self.token;//用户验证

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/supplierInfo" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.company.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"company"]];
                strongSelf.legal_person.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"legal_person"]];
                strongSelf.card_id.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"card_id"]];
                strongSelf.credit_code.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"credit_code"]];
                [strongSelf.business_license_img sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][@"business_license_img"]]];

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
-(void)submitSupplierInfoRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = self.uid;//用户id
    parameters[@"token"] = self.token;//用户验证
    parameters[@"card_front_img"] = self.card_front_url;//正面照
    parameters[@"card_back_img"] = self.card_back_url;//反面照

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/realAuthentication" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            MSUserInfo *info = [MSUserInfo new];
            info.uid = strongSelf.uid;
            info.token = strongSelf.token;
            info.utype = @"2";
            [MSUserManager sharedInstance].curUserInfo = info;
            [[MSUserManager sharedInstance] saveUserInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                HXTabBarController *tab = [[HXTabBarController alloc] init];
                [UIApplication sharedApplication].keyWindow.rootViewController = tab;
                
                //推出主界面出来
                CATransition *ca = [CATransition animation];
                ca.type = @"movein";
                ca.duration = 0.5;
                [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
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
                [strongSelf.card_front_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                strongSelf.card_front_url = imageUrl;
            }else {
                [strongSelf.card_back_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                strongSelf.card_back_url = imageUrl;
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
