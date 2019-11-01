//
//  GXInviteVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXInviteVC.h"
#import "SGQRCode.h"

@interface GXInviteVC ()
@property (weak, nonatomic) IBOutlet UIImageView *code_img;
@property (weak, nonatomic) IBOutlet UILabel *share_code;
@property (weak, nonatomic) IBOutlet UILabel *relu_txt;

@end

@implementation GXInviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"邀请有礼"];
    [self getInviteDataRequest];
}
-(void)getInviteDataRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"inviteData" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf showInviteData:responseObject[@"data"]];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)showInviteData:(NSDictionary *)result
{
    self.code_img.image = [SGQRCodeObtain generateQRCodeWithData:result[@"register_url"] size:self.code_img.hxn_width];
    self.share_code.text = [NSString stringWithFormat:@"我的邀请码：%@",result[@"share_code"]];
    [self.relu_txt setTextWithLineSpace:5.f withString:result[@"act_rule"] withFont:[UIFont systemFontOfSize:13]];
}
@end
