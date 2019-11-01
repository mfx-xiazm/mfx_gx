//
//  GXOffLineReportVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXOffLineReportVC.h"
#import "FSActionSheet.h"
#import "zhAlertView.h"
#import <zhPopupController.h>

@interface GXOffLineReportVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *shop_name;
@property (weak, nonatomic) IBOutlet UITextField *area_name;
@property (weak, nonatomic) IBOutlet UITextField *town_name;
@property (weak, nonatomic) IBOutlet UITextField *goods_name;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UIImageView *code_img;
@property (weak, nonatomic) IBOutlet UIImageView *shop_img;
@property (weak, nonatomic) IBOutlet UITextField *tips_desc;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
/* 点击的图片 */
@property(nonatomic,assign) NSInteger imgTag;
@property (copy, nonatomic) NSString *code_img_url;
@property (copy, nonatomic) NSString *shop_img_url;
@end

@implementation GXOffLineReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"窜货举报"];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImgTaped:)];
    [self.code_img addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImgTaped:)];
    [self.shop_img addGestureRecognizer:tap2];
    
    hx_weakify(self);
    [self.submitBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.shop_name hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写被举报门店名称"];
            return NO;
        }
        if (![strongSelf.area_name hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写举报门店省-市-区/县"];
            return NO;
        }
        if (![strongSelf.town_name hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写举报门店街道/乡镇"];
            return NO;
        }
        if (![strongSelf.goods_name hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写窜货商品名称"];
            return NO;
        }
        if (![strongSelf.price hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写销售价格"];
            return NO;
        }
        if (!strongSelf.code_img_url) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传带有清晰溯源码的照片"];
            return NO;
        }
        if (!strongSelf.shop_img_url) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传门店门头或店内陈列商品照片"];
            return NO;
        }
        if (![strongSelf.username hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写您的姓名"];
            return NO;
        }
        if (![strongSelf.phone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写您的联系电话"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf offlineReportRequest:button];
    }];
}

-(void)chooseImgTaped:(UITapGestureRecognizer *)tap
{
    self.imgTag = tap.view.tag;
    
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
            [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionTop title:@"相机不可用"];
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
            [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionTop title:@"相册不可用"];
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
        [strongSelf upImageRequestWithImage:@[info[UIImagePickerControllerEditedImage]] completedCall:^(NSString *imageUrl,NSString * imagePath) {
            if (strongSelf.imgTag == 1) {
                [strongSelf.code_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                strongSelf.code_img_url = imageUrl;
            }else{
                [strongSelf.shop_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                strongSelf.shop_img_url = imageUrl;
            }
        }];
    }];
}
// 上传单张图
-(void)upImageRequestWithImage:(NSArray *)images completedCall:(void(^)(NSString * imageUrl,NSString * imagePath))completedCall
{
    [HXNetworkTool uploadImagesWithURL:HXRC_M_URL action:@"uploadFile" parameters:@{} name:@"file" images:images fileNames:nil imageScale:0.8 imageType:@"png" progress:nil success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            completedCall(responseObject[@"data"][@"path"],responseObject[@"data"][@"imgPath"]);
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)offlineReportRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"tips_type"] = @"线下违规窜货";
    parameters[@"area_name"] = self.area_name.text;
    parameters[@"town_name"] = self.town_name.text;
    parameters[@"shop_name"] = self.shop_name.text;
    parameters[@"goods_name"] = self.goods_name.text;
    parameters[@"price"] = self.price.text;
    parameters[@"code_img"] = self.code_img_url;
    parameters[@"shop_img"] = self.shop_img_url;
    parameters[@"tips_desc"] = [self.tips_desc hasText]?self.tips_desc.text:@"";
    parameters[@"username"] = self.username.text;
    parameters[@"phone"] = self.phone.text;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"tipsOffline" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"提交" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"提交" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
