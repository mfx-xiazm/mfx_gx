//
//  HXTabBarController.m
//  HX
//
//  Created by hxrc on 17/3/2.
//  Copyright © 2017年 HX. All rights reserved.
//

#import "HXTabBarController.h"
#import "UIImage+HXNExtension.h"
#import "HXNavigationController.h"
#import "GXHomeVC.h"
#import "GXCategoryVC.h"
#import "GXRegionalVC.h"
#import "GXCartVC.h"
#import "GXMyVC.h"

@interface HXTabBarController ()<UITabBarControllerDelegate>

@end

@implementation HXTabBarController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    attrs[NSForegroundColorAttributeName] = UIColorFromRGB(0x999999);
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = HXControlBg;
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // 添加母婴店子控制器
    [self setupChildVc:[[GXHomeVC alloc] init] title:@"首页" image:@"首页图标" selectedImage:@"首页图标选中"];
    [self setupChildVc:[[GXCategoryVC alloc] init] title:@"分类" image:@"分类图标" selectedImage:@"分类图标选中"];
    [self setupChildVc:[[GXRegionalVC alloc] init] title:@"控区控价" image:@"控区控价图标" selectedImage:@"控区控价图标选中"];
    [self setupChildVc:[[GXCartVC alloc] init] title:@"购物车" image:@"购物车图标" selectedImage:@"购物车图标选中"];
    [self setupChildVc:[[GXMyVC alloc] init] title:@"我的" image:@"我的图标" selectedImage:@"我的图标选中"];
    
    self.delegate = self;
    
    // 设置透明度和背景颜色
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    self.tabBar.translucent = NO;//这句表示取消tabBar的透明效果。
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setShadowImage:[UIImage imageWithColor:HXRGBAColor(235, 235, 235, 0.8) size:CGSizeMake(1, 0.5)]];
}
/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.title = title;
    
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 包装一个自定义的导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}
#pragma mark -- ————— UITabBarController 代理 —————
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    /*
     if ([viewController.tabBarItem.title isEqualToString:@"聊天"] || [viewController.tabBarItem.title isEqualToString:@"订单"]){
     if (![MSUserManager sharedInstance].isLogined){
     MULoginVC *lvc = [MULoginVC new];
     HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:lvc];
     [tabBarController.selectedViewController presentViewController:nav animated:YES completion:nil];
     return NO;
     }else{ // 如果已登录
     return YES;
     }
     }else{
     return YES;
     }
     */
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
