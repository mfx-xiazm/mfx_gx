//
//  GXInviteVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXInviteVC.h"
#import "SGQRCode.h"
#import <UMShare/UMShare.h>
#import "GXShareView.h"
#import <zhPopupController.h>

@interface GXInviteVC ()
@property (weak, nonatomic) IBOutlet UIImageView *code_img;
@property (weak, nonatomic) IBOutlet UILabel *share_code;
@property (weak, nonatomic) IBOutlet UILabel *relu_txt;
/* 邀请注册地址 */
@property(nonatomic,copy) NSString *register_url;
@end

@implementation GXInviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"邀请有礼"];
    [self startShimmer];
    [self getInviteDataRequest];
}
-(void)getInviteDataRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/inviteData" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.register_url = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"register_url"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf showInviteData:responseObject[@"data"]];
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
-(void)showInviteData:(NSDictionary *)result
{
    self.code_img.image = [SGQRCodeObtain generateQRCodeWithData:result[@"register_url"] size:self.code_img.hxn_width];
    self.share_code.text = [NSString stringWithFormat:@"我的邀请码：%@",result[@"share_code"]];
    [self.relu_txt setTextWithLineSpace:5.f withString:result[@"act_rule"] withFont:[UIFont systemFontOfSize:13]];
}
- (IBAction)inviteClicked:(UIButton *)sender {
    GXShareView *share  = [GXShareView loadXibView];
    share.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 180.f);
    hx_weakify(self);
    share.shareTypeCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        if (index == 1) {
            [strongSelf shareImageToPlatformType:UMSocialPlatformType_WechatTimeLine];
        }else{
            [strongSelf shareImageToPlatformType:UMSocialPlatformType_WechatSession];
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:share duration:0.25 springAnimated:NO];
}
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //创建图片内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"呱选-邀请有礼" descr:@"注册账号赢好礼" thumImage:HXGetImage(@"Icon-share")];
    //如果有缩略图，则设置缩略图
    shareObject.webpageUrl = self.register_url;

    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}
@end
