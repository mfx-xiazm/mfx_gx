//
//  GXMyLicenceVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMyLicenceVC.h"

@interface GXMyLicenceVC ()
@property (weak, nonatomic) IBOutlet UIView *food_lince_view;
@property (weak, nonatomic) IBOutlet UIView *shop_lince_view;

@property (weak, nonatomic) IBOutlet UIImageView *business_license_img;
@property (weak, nonatomic) IBOutlet UIImageView *shop_front_img;
@property (weak, nonatomic) IBOutlet UIImageView *shop_inside_img;
@property (weak, nonatomic) IBOutlet UIImageView *card_front_img;
@property (weak, nonatomic) IBOutlet UIImageView *card_back_img;
@property (weak, nonatomic) IBOutlet UIImageView *food_license_img;

@end

@implementation GXMyLicenceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:[self.seaType isEqualToString:@"1"]?@"资质信息":@"视频经营许可证"];
    self.food_lince_view.hidden = [self.seaType isEqualToString:@"1"]?YES:NO;
    self.shop_lince_view.hidden = [self.seaType isEqualToString:@"1"]?NO:YES;

    [self getNaturalDataRequest];
}

-(void)getNaturalDataRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"seaType"] = self.seaType;//查询类型 1查询资质信息 2查询食品经营许可证

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"naturalData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleNaturalData:responseObject[@"data"]];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)handleNaturalData:(NSDictionary *)result
{
    if ([self.seaType isEqualToString:@"1"]) {
        [self.business_license_img sd_setImageWithURL:[NSURL URLWithString:result[@"business_license_img"]]];
        [self.shop_front_img sd_setImageWithURL:[NSURL URLWithString:result[@"shop_front_img"]]];
        [self.shop_inside_img sd_setImageWithURL:[NSURL URLWithString:result[@"shop_inside_img"]]];
        [self.card_front_img sd_setImageWithURL:[NSURL URLWithString:result[@"card_front_img"]]];
        [self.card_back_img sd_setImageWithURL:[NSURL URLWithString:result[@"card_back_img"]]];
    }else{
        [self.food_license_img sd_setImageWithURL:[NSURL URLWithString:result[@"food_license_img"]]];
    }
}
@end
