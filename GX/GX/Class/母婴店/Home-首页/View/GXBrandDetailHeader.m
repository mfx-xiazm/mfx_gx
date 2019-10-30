//
//  GXBrandDetailHeader.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXBrandDetailHeader.h"
#import "GXBrandDetail.h"

@interface GXBrandDetailHeader ()
@property (weak, nonatomic) IBOutlet UIImageView *brand_logo;
@property (weak, nonatomic) IBOutlet UILabel *brand_name;
@property (weak, nonatomic) IBOutlet UIButton *apply_state;
@property (weak, nonatomic) IBOutlet UILabel *brand_desc;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applyBtnHeight;

@end
@implementation GXBrandDetailHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setBrandDetail:(GXBrandDetail *)brandDetail
{
    _brandDetail = brandDetail;
    [self.brand_logo sd_setImageWithURL:[NSURL URLWithString:_brandDetail.brand_logo]];
    self.brand_name.text = _brandDetail.brand_name;
    [self.brand_desc setTextWithLineSpace:5.f withString:(_brandDetail.brand_desc && _brandDetail.brand_desc.length)?_brandDetail.brand_desc:@"" withFont:[UIFont systemFontOfSize:13]];
    /** 0未加盟 1审核中 2合作中 3审核驳回 4合作取消 */
    if ([_brandDetail.apply_status isEqualToString:@"2"]) {// 合作中 没有加盟按钮
        self.applyBtn.hidden = YES;
        self.applyBtnHeight.constant = 0.f;
        [self.apply_state setTitle:@"合作中" forState:UIControlStateNormal];
        [self.apply_state setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.apply_state setBackgroundColor:HXRGBAColor(234, 74, 92, 0.3)];
    }else{
        self.applyBtn.hidden = NO;
        self.applyBtnHeight.constant = 30.f;
        if ([_brandDetail.apply_status isEqualToString:@"0"]) {//未加盟
            [self.applyBtn setTitle:@"申请加盟" forState:UIControlStateNormal];
            [self.applyBtn setBackgroundColor:UIColorFromRGB(0xEA4A5C)];
            [self.apply_state setTitle:@"未加盟" forState:UIControlStateNormal];
            [self.apply_state setTitleColor:UIColorFromRGB(0x131D2D) forState:UIControlStateNormal];
            [self.apply_state setBackgroundColor:UIColorFromRGB(0xE6E6E6)];
        }else if ([_brandDetail.apply_status isEqualToString:@"1"]) {//审核中
            [self.applyBtn setTitle:@"申请加盟审核中" forState:UIControlStateNormal];
            [self.applyBtn setBackgroundColor:HXRGBAColor(234, 74, 92, 0.3)];
            [self.apply_state setTitle:@"审核中" forState:UIControlStateNormal];
            [self.apply_state setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.apply_state setBackgroundColor:HXRGBAColor(234, 74, 92, 0.3)];
        }else if ([_brandDetail.apply_status isEqualToString:@"3"]) {//审核驳回
            [self.applyBtn setTitle:@"重新申请加盟" forState:UIControlStateNormal];
            [self.applyBtn setBackgroundColor:UIColorFromRGB(0xEA4A5C)];
            [self.apply_state setTitle:@"审核驳回" forState:UIControlStateNormal];
            [self.apply_state setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.apply_state setBackgroundColor:HXRGBAColor(234, 74, 92, 0.3)];
        }else{
            [self.applyBtn setTitle:@"重新申请加盟" forState:UIControlStateNormal];
            [self.applyBtn setBackgroundColor:UIColorFromRGB(0xEA4A5C)];
            [self.apply_state setTitle:@"合作取消" forState:UIControlStateNormal];
            [self.apply_state setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.apply_state setBackgroundColor:HXRGBAColor(234, 74, 92, 0.3)];
        }
    }
}
- (IBAction)applyBtnClicked:(UIButton *)sender {
    if ([_brandDetail.apply_status isEqualToString:@"0"] || [_brandDetail.apply_status isEqualToString:@"3"] || [_brandDetail.apply_status isEqualToString:@"4"]) {
        if (self.applyJoinCall) {
            self.applyJoinCall();
        }
    }
}

@end
