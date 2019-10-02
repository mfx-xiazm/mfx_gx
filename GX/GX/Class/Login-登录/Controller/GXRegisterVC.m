//
//  GXRegisterVC.m
//  GX
//
//  Created by 夏增明 on 2019/9/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXRegisterVC.h"
#import "GXRegisterAuthVC.h"

@interface GXRegisterVC ()

@end

@implementation GXRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"注册"];
}

- (IBAction)goLoginClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextClicked:(UIButton *)sender {
    GXRegisterAuthVC *svc = [GXRegisterAuthVC new];
    [self.navigationController pushViewController:svc animated:YES];
}

@end
