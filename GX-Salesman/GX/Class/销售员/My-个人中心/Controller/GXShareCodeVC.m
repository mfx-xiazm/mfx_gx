//
//  GXShareCodeVC.m
//  GX
//
//  Created by huaxin-01 on 2020/6/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXShareCodeVC.h"
#import "SGQRCode.h"

@interface GXShareCodeVC ()
@property (weak, nonatomic) IBOutlet UIImageView *shareCodeImg;
@property (weak, nonatomic) IBOutlet UILabel *shareCodeLabel;
@end

@implementation GXShareCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hbd_barAlpha = 0.0;
    [self.navigationItem setTitle:@"邀请码"];
    self.shareCodeImg.image = [SGQRCodeObtain generateQRCodeWithData:self.register_url size:self.shareCodeImg.hxn_width];
    self.shareCodeLabel.text = [NSString stringWithFormat:@"我的邀请码：%@",self.shareCode];
}

@end
