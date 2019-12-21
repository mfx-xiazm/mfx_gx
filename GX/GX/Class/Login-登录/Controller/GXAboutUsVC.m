//
//  GXAboutUsVC.m
//  GX
//
//  Created by 夏增明 on 2019/12/20.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXAboutUsVC.h"
#import "GXRegisterVC.h"

@interface GXAboutUsVC ()

@end

@implementation GXAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"呱选介绍"];
}

-(IBAction)nextClicked
{
    GXRegisterVC *rvc = [GXRegisterVC new];
    [self.navigationController pushViewController:rvc animated:YES];
}
@end
