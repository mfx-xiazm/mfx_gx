//
//  GXStoreMsgVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXStoreMsgVC.h"
#import "GXStoreDetail.h"
#import <ZLPhotoActionSheet.h>

@interface GXStoreMsgVC ()
@property (weak, nonatomic) IBOutlet UIImageView *shop_front_img;
@property (weak, nonatomic) IBOutlet UILabel *shop_name;
@property (weak, nonatomic) IBOutlet UILabel *evl_level;
@property (weak, nonatomic) IBOutlet UILabel *store_level;
@property (weak, nonatomic) IBOutlet UIImageView *license_img;
@property (weak, nonatomic) IBOutlet UILabel *shop_desc;
@property (weak, nonatomic) IBOutlet UILabel *brand_name;
@property (weak, nonatomic) IBOutlet UILabel *region;
@property (weak, nonatomic) IBOutlet UILabel *open_time;
/* 店铺信息 */
@property(nonatomic,strong) GXStoreDetail *storeDetail;

@end

@implementation GXStoreMsgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"店铺详情"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClicked:)];
    [self.license_img addGestureRecognizer:tap];
    
    [self startShimmer];
    [self getShopDetailRequest];
}
-(void)imgTapClicked:(UITapGestureRecognizer *)tap
{
    if (self.storeDetail.food_license_img && self.storeDetail.food_license_img.length) {
        NSMutableArray * items = [NSMutableArray array];
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        temp[@"ZLPreviewPhotoObj"] = [NSURL URLWithString:self.storeDetail.food_license_img];
        temp[@"ZLPreviewPhotoTyp"] = @(ZLPreviewPhotoTypeURLImage);
        [items addObject:temp];
        
        ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
        actionSheet.configuration.navBarColor = HXControlBg;
        actionSheet.configuration.statusBarStyle = UIStatusBarStyleLightContent;
        actionSheet.sender = self;
        [actionSheet previewPhotos:items index:tap.view.tag hideToolBar:YES complete:^(NSArray * _Nonnull photos) {
            
        }];
    }else{
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"商家未配置食品许可证"];
    }
}
-(void)getShopDetailRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"provider_uid"] = self.provider_uid;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getShopDetail" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.storeDetail = [GXStoreDetail yy_modelWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleStoreInfo];
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
-(void)handleStoreInfo
{
    [self.shop_front_img sd_setImageWithURL:[NSURL URLWithString:self.storeDetail.shop_front_img] placeholderImage:HXGetImage(@"Icon-share")];
    self.shop_name.text = self.storeDetail.shop_name;
    self.evl_level.text = [NSString stringWithFormat:@"综合评分：%@",self.storeDetail.evl_level];
    [self.store_level setTextWithLineSpace:5.f withString:[NSString stringWithFormat:@"描述相符：%@\n发货速度：%@\n响应速度：%@",self.storeDetail.desc_level,self.storeDetail.deliver_level,self.storeDetail.answer_level] withFont:[UIFont systemFontOfSize:13]];
    [self.license_img sd_setImageWithURL:[NSURL URLWithString:self.storeDetail.food_license_img]];
    [self.shop_desc setTextWithLineSpace:5.f withString:(self.storeDetail.shop_desc.length)?self.storeDetail.shop_desc:@"——" withFont:[UIFont systemFontOfSize:13]];
    [self.brand_name setTextWithLineSpace:5.f withString:(self.storeDetail.brand_name.length)?self.storeDetail.brand_name:@"" withFont:[UIFont systemFontOfSize:13]];
    self.region.text = [NSString stringWithFormat:@"%@%@%@",self.storeDetail.province_name,self.storeDetail.city_name,self.storeDetail.town_name];
    self.open_time.text = (self.storeDetail.shop_open_time.length>10) ?[self.storeDetail.shop_open_time substringToIndex:10]:self.storeDetail.shop_open_time;
}
@end
