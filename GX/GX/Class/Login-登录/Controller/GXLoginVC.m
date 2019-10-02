//
//  GXLoginVC.m
//  GX
//
//  Created by 夏增明 on 2019/9/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXLoginVC.h"
#import "HXTabBarController.h"
#import "GXChangePwdVC.h"
#import "GXRegisterVC.h"

@interface GXLoginVC ()

@end

@implementation GXLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"登录"];
}
- (IBAction)loginClicked:(UIButton *)sender {
    HXTabBarController *tab = [[HXTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tab;
    
    //推出主界面出来
    CATransition *ca = [CATransition animation];
    ca.type = @"movein";
    ca.duration = 0.5;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
}
- (IBAction)forgetClicked:(UIButton *)sender {
    GXChangePwdVC *pvc = [GXChangePwdVC new];
    [self.navigationController pushViewController:pvc animated:YES];
}
- (IBAction)registerClicked:(UIButton *)sender {
    GXRegisterVC *rvc = [GXRegisterVC new];
    [self.navigationController pushViewController:rvc animated:YES];
}

@end
