//
//  GXMyVC.m
//  GX
//
//  Created by 夏增明 on 2019/9/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMyVC.h"
#import "FSActionSheet.h"
#import "GXMySetVC.h"
#import "GXWebContentVC.h"
#import "GXMyCollectVC.h"
#import "GXMyBusinessVC.h"
#import "GXMyCouponVC.h"
#import "GXInviteVC.h"
#import "GXComplainVC.h"
#import "GXMyAddressVC.h"
#import "GXHelpVC.h"
#import "GXReportVC.h"
#import "GXMemberVC.h"
#import "GXMyIdeaVC.h"
#import "GXMyOrderVC.h"
#import "GXMineData.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "UIView+WZLBadge.h"

@interface GXMyVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/* 个人信息 */
@property(nonatomic,strong) GXMineData *mineData;
@property (weak, nonatomic) IBOutlet UIImageView *shop_img;
@property (weak, nonatomic) IBOutlet UILabel *shop_name;
@property (weak, nonatomic) IBOutlet UIButton *user_level;
@property (weak, nonatomic) IBOutlet UIButton *sale_man;

@property (weak, nonatomic) IBOutlet UIImageView *noPayView;
@property (weak, nonatomic) IBOutlet UIImageView *noDeliverView;
@property (weak, nonatomic) IBOutlet UIImageView *noReceiveView;
@property (weak, nonatomic) IBOutlet UIImageView *noEvaluateView;

@end

@implementation GXMyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(settingBtnClicked) image:HXGetImage(@"管理设置") imageEdgeInsets:UIEdgeInsetsZero];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeaderTap:)];
    [self.shop_img addGestureRecognizer:tap];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMemberRequest];
    [self getOrderNumRequest];
}
#pragma mark -- 业务逻辑
-(void)getMemberRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getMineData" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.mineData = [GXMineData yy_modelWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleMineData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getOrderNumRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getOrderNum" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([responseObject[@"data"][@"unPayNum"] integerValue] != 0) {
                    [strongSelf.noPayView showBadgeWithStyle:WBadgeStyleNumber value:[responseObject[@"data"][@"unPayNum"] integerValue] animationType:WBadgeAnimTypeNone];
                }else{
                    [strongSelf.noPayView clearBadge];
                }
                
                if ([responseObject[@"data"][@"unDeliverNum"] integerValue] != 0) {
                    [strongSelf.noDeliverView showBadgeWithStyle:WBadgeStyleNumber value:[responseObject[@"data"][@"unDeliverNum"] integerValue] animationType:WBadgeAnimTypeNone];
                }else{
                    [strongSelf.noDeliverView clearBadge];
                }
                
                if ([responseObject[@"data"][@"unReceiveNum"] integerValue] != 0) {
                    [strongSelf.noReceiveView showBadgeWithStyle:WBadgeStyleNumber value:[responseObject[@"data"][@"unReceiveNum"] integerValue] animationType:WBadgeAnimTypeNone];
                }else{
                    [strongSelf.noReceiveView clearBadge];
                }
                
                if ([responseObject[@"data"][@"unEvaNum"] integerValue] != 0) {
                    [strongSelf.noEvaluateView showBadgeWithStyle:WBadgeStyleNumber value:[responseObject[@"data"][@"unEvaNum"] integerValue] animationType:WBadgeAnimTypeNone];
                }else{
                    [strongSelf.noEvaluateView clearBadge];
                }
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)handleMineData
{
    [self.shop_img sd_setImageWithURL:[NSURL URLWithString:self.mineData.shop_front_img] placeholderImage:HXGetImage(@"Icon-logo")];
    self.shop_name.text = self.mineData.shop_name;
    if (self.mineData.level_id && self.mineData.level_id.length) {
        self.user_level.hidden = NO;
        [self.user_level setTitle:self.mineData.level_name forState:UIControlStateNormal];
    }else{
        self.user_level.hidden = YES;
    }
    
    if (self.mineData.saleman_phone && self.mineData.saleman_phone.length) {
        self.sale_man.hidden = NO;
    }else{
        self.sale_man.hidden = YES;
    }
}
-(void)editAvatarRequest:(NSString *)imageUrl
{
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/editAvatar" parameters:@{@"avatar":imageUrl} success:^(id responseObject) {
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 点击事件
-(void)changeHeaderTap:(UITapGestureRecognizer *)tap
{
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
/** 客服经理 */
- (IBAction)contactBtnClicked:(UIButton *)sender {
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:@"客户经理" delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[[NSString stringWithFormat:@"%@(%@)",self.mineData.saleman_phone,self.mineData.saleman_name]]];
    hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        hx_strongify(weakSelf);
        if (selectedIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",strongSelf.mineData.saleman_phone]]];
        }
    }];
}
/** 权益中心 */
- (IBAction)memberBtnClicked:(UIButton *)sender {
    GXMemberVC *mvc = [GXMemberVC new];
    mvc.mineData = self.mineData;
    [self.navigationController pushViewController:mvc animated:YES];
}
/** 设置 */
- (void)settingBtnClicked {
    GXMySetVC *svc = [GXMySetVC new];
    svc.mineData = self.mineData;
    [self.navigationController pushViewController:svc animated:YES];
}
/** 我的生意 */
- (IBAction)myBusnessBtnClicked:(UIButton *)sender {
    GXMyBusinessVC *bvc = [GXMyBusinessVC new];
    [self.navigationController pushViewController:bvc animated:YES];
}
/** 优惠券 */
- (IBAction)myCouponClicked:(UIButton *)sender {
    GXMyCouponVC *cvc = [GXMyCouponVC new];
    [self.navigationController pushViewController:cvc animated:YES];
}
/** 我的清单 */
- (IBAction)myCollectBtnClicked:(UIButton *)sender {
    GXMyCollectVC *cvc = [GXMyCollectVC new];
    [self.navigationController pushViewController:cvc animated:YES];
}
/** 我的订单 */
- (IBAction)myOrderClicked:(UIButton *)sender {
    GXMyOrderVC *ovc = [GXMyOrderVC new];
    ovc.selectIndex = sender.tag;
    [self.navigationController pushViewController:ovc animated:YES];
}
/** 其他操作 */
- (IBAction)myOtherBtnClicked:(UIButton *)sender {
    if (sender.tag == 0) {
        GXInviteVC *ivc = [GXInviteVC new];
        [self.navigationController pushViewController:ivc animated:YES];
    }else if (sender.tag == 1){
        GXMyAddressVC *avc = [GXMyAddressVC new];
        [self.navigationController pushViewController:avc animated:YES];
    }else if (sender.tag == 2){
        GXWebContentVC *wvc = [GXWebContentVC new];
        wvc.navTitle = @"售后标准";
        wvc.isNeedRequest = YES;
        wvc.requestType = 5;
        [self.navigationController pushViewController:wvc animated:YES];
    }else if (sender.tag == 3){
        GXMemberVC *mvc = [GXMemberVC new];
        mvc.mineData = self.mineData;
        [self.navigationController pushViewController:mvc animated:YES];
    }else if (sender.tag == 4){
        GXHelpVC *hvc = [GXHelpVC new];
        [self.navigationController pushViewController:hvc animated:YES];
    }else if (sender.tag == 5){
        GXMyIdeaVC *cvc = [GXMyIdeaVC new];
        [self.navigationController pushViewController:cvc animated:YES];
    }else if (sender.tag == 6){
        //GXComplainVC *cvc = [GXComplainVC new];
        //[self.navigationController pushViewController:cvc animated:YES];
        GXWebContentVC *wvc = [GXWebContentVC new];
        wvc.navTitle = @"我要投诉";
        wvc.isNeedRequest = YES;
        wvc.requestType = 7;
        [self.navigationController pushViewController:wvc animated:YES];
    }else if (sender.tag == 7){
        GXReportVC *rvc = [GXReportVC new];
        [self.navigationController pushViewController:rvc animated:YES];
    }else if (sender.tag == 8){
        FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:@"联系我们" delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[[NSString stringWithFormat:@"%@",self.mineData.platform_tel]]];
        hx_weakify(self);
        [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
            hx_strongify(weakSelf);
            if (selectedIndex == 0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",strongSelf.mineData.platform_tel]]];
            }
        }];
    }else if (sender.tag == 9){
        GXWebContentVC *wvc = [GXWebContentVC new];
        wvc.isNeedRequest = NO;
        wvc.url = @"https://ykf-webchat.7moor.com/wapchat.html?accessId=e1c9ecc0-2162-11ea-849d-c5eead77ac50&fromUrl=&urlTitle";
        [self.navigationController pushViewController:wvc animated:YES];
    }else{
        GXWebContentVC *wvc = [GXWebContentVC new];
        wvc.navTitle = @"申请供货";
        wvc.isNeedRequest = YES;
        wvc.requestType = 2;
        [self.navigationController pushViewController:wvc animated:YES];
    }
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
            [strongSelf.shop_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
            [strongSelf editAvatarRequest:imageUrl];
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
